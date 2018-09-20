require 'sinatra/base'
require 'haml'
require 'octokit'
require 'rest-client'
require 'json'
require 'pathname'
require 'uri'
require_relative '../txn'
require_relative 'register'

module D2HUB
  class BuildController < D2hubBase
    register ControllerRegister

    get '/builds/github' do
      haml :build_github
    end

    get '/builds/github/:github_host' do |github_host|
      @gh_repos = GetGitHubRepositories.run github_host: github_host,
                                            user_name: user_id
      @github_host = github_host
      haml :build_github_host
    end

    get '/callback/:github_host' do |github_host|
      git_info = D2HUB::github_info(github_host)

      result = RestClient.post("https://#{git_info[:host]}/login/oauth/access_token",
                               {:client_id => git_info[:client_id],
                                :client_secret => git_info[:client_secret],
                                :code => params['code']},
                               :accept => :json,
                               :verify_ssl => false)

      access_token = JSON.parse(result)['access_token']
      redirect '/builds/github' if access_token.nil?

      InsertGitHubAccessToken.run user_name: user_id,
                                  github_host: git_info[:host],
                                  access_token: access_token
      redirect "/builds/github/#{git_info[:host]}"
    end

    get '/builds/github/:github_host/repos/:github_repo_id/add' do |github_host, github_repo_id|
      @orgs = GetOrganizations.run user_name: user_id
      @error = params[:error]
      @org_name = params[:org_name] || D2HUB::valid_org_name(user_id)
      @repo_name = params[:repo_name]
      @github_host = github_host
      @github_repo_id = github_repo_id
      haml :build_github_repo
    end

    get '/build-histories/:build_history_id' do |build_history_id|
      @build_history = GetBuildHistory.run id: build_history_id
      halt 404 if @build_history.nil?
      @repo = Repository.first id: @build_history[:repository_id]
      halt 404 if @repo.nil?

      @build_history.dockerbuild_arg = '/' if @build_history.dockerbuild_arg.nil?
      @build_history.dockerfile_location = '/' if @build_history.dockerfile_location.nil?
      @build_history.dockerfile_name = 'Dockerfile' if @build_history.dockerfile_name.nil?
      @dockerfile_path = File.join(@build_history.dockerfile_location, @build_history.dockerfile_name)
      haml :build_history
    end

    post '/build-histories/:build_history_id/rebuild' do |build_history_id|
      repo_info = GetRepoInfoByBuildHistory.run build_history_id: build_history_id
      redirect to("/orgs/#{repo_info[:org][:name]}/repos/#{repo_info[:repo][:name]}#buildDetail") unless has_authority_of_repository? repo_info[:org][:name], repo_info[:repo][:name]

      DockerImageBuildByHistory.run user_name: user_id,
                                    build_history_id: build_history_id
      redirect to("/orgs/#{repo_info[:org][:name]}/repos/#{repo_info[:repo][:name]}#buildDetail")
    end

    post '/dockerbuild' do # docker build webhook 처리
      STDERR.puts "[automated build] request.env: #{request.env}"
      gh_event = request.env['HTTP_X_GITHUB_EVENT']
      if gh_event == 'ping'
        STDERR.puts '[automated build] get ping event'
        halt 200
      end

      if gh_event == 'push'
        gh_payload = JSON.parse(request.body.read)
        STDERR.puts "[automated build] github playload: #{gh_payload}"
        build_result = DockerImageBuildByPush.run gh_payload: gh_payload
        halt 400 if build_result.nil?

        status 200
      else
        status 400
      end
    end

    post '/build-tags/:build_tag_id/build' do |build_tag_id|
      repo_info = GetRepoInfoByBuildTag.run build_tag_id: build_tag_id
      redirect to("#{URI(back).path}#buildDetail") unless has_authority_of_repository? repo_info[:org][:name], repo_info[:repo][:name]

      DockerImageBuildManually.run user_name: user_id,
                                   build_tag_id: build_tag_id
      redirect to("#{URI(back).path}#buildDetail")
    end

    post '/buildresult' do
      build_result = JSON.parse(request.body.read)
      if build_result['isSuccess']
        EditBuildHistory.run id: build_result['buildID'],
                             status: 'success',
                             docker_image_name: build_result['dockerImageName'],
                             logs: build_result['logs']
        # deploy to the marathon
        build_spec = build_result['buildSpec']
        marathon_deploys = GetMarathonDeploys.run build_tag_id: build_spec['buildTagID']
        marathon_deploys.each_with_index do |deploy, d_index|
          raw_github_url = "#{build_spec['githubHost']}/raw"
          if build_spec['githubHost'] == 'github.kakaocorp.com'
            raw_github_url = "raw.#{build_spec['githubHost']}"
          end
          json_url = "https://#{build_spec['githubToken']}@#{raw_github_url}/#{build_spec['githubOrgName']}/#{build_spec['githubRepoName']}/#{build_spec['gitBranchName']}/#{Pathname.new(deploy[:marathon_json_path]).cleanpath}"
          command = "app -marathonURL #{deploy[:marathon_url]} -jsonURL #{json_url} -dockerImage #{build_result['dockerImageName']}"
          if deploy[:marathon_basic_auth] != ''
            command += " -marathonAuth #{deploy[:marathon_basic_auth]}"
          end

          if deploy[:env_vars] != ''
            deploy[:env_vars].split("\n").each do |env_var|
              command += " -env #{env_var}"
            end
          end

          if deploy[:label_vars] != ''
            deploy[:label_vars].split("\n").each do |label_var|
              command += " -label #{label_var}"
            end
          end

          if build_spec['watchCenterID'] != ''
            command += " -watchCenterID #{build_spec['watchCenterID']}"
          end
          deploy_payload = {
              schedule: 'R1//PT1S',
              scheduleTimeZone: 'Asia/Seoul',
              name: "deploy-marathon-#{build_result['buildID']}-#{d_index + 1}",
              container: {
                  type: 'DOCKER',
                  image: ENV['DEPLOY_MARATHON_DOCKER_IMAGE'],
                  forcePullImage: true
              },
              cpus: 0.05,
              mem: 64,
              command: command
          }
          STDERR.puts "[Deploy to marathon using chronos] #{JSON.pretty_generate(deploy_payload)}"
          DeployToMarathon.run  payload: deploy_payload.to_json,
                                auth: ENV['CHRONOS_BASIC_AUTH']
        end

        # deploy to the kubernetes
        build_spec = build_result['buildSpec']
        kubernetes_deploys = GetKubernetesDeploys.run build_tag_id: build_spec['buildTagID']
        kubernetes_deploys.each_with_index do |deploy, d_index|
          raw_github_url = "#{build_spec['githubHost']}/raw"
          if build_spec['githubHost'] == 'github.kakaocorp.com'
            raw_github_url = "raw.#{build_spec['githubHost']}"
          end
          yaml_url = "https://#{build_spec['githubToken']}@#{raw_github_url}/#{build_spec['githubOrgName']}/#{build_spec['githubRepoName']}/#{build_spec['gitBranchName']}/#{Pathname.new(deploy[:kubernetes_yaml_path]).cleanpath}"
          command = ['deploy-kubernetes',
           "-kubernetesURL=#{deploy[:kubernetes_url]}",
           "-kubernetesYAMLURL=#{yaml_url}",
           "-imageName=#{build_result['dockerImageName']}",
           "-kubeConfig=#{deploy[:kubernetes_kubeconfig]}"]

          if deploy[:env_vars] != ''
            deploy[:env_vars].split("\n").each do |env_var|
              command.push("-env=#{env_var}")
            end
          end

          if build_spec['watchCenterID'] != ''
            command.push("-watchCenterID=#{build_spec['watchCenterID']}")
          end

          deploy_job_spec = {apiVersion: 'batch/v1',
                             kind: 'Job',
                             metadata:
                                 {name: "deploy-kubernetes-#{build_result['buildID']}-#{d_index + 1}"},
                             spec:
                                 {backoffLimit: 3,
                                  activeDeadlineSeconds: 180,
                                  template:
                                      {spec:
                                           {containers:
                                                [{name: "deploy-kubernetes-#{build_result['buildID']}-#{d_index + 1}",
                                                  image: "#{ENV['DEPLOY_KUBERNETES_DOCKER_IMAGE']}",
                                                  command: command
                                                 }],
                                            restartPolicy: 'Never',
                                           },
                                      },
                                 }
                            }

          STDERR.puts "[Deploy to kubernetes using job] #{JSON.pretty_generate(deploy_job_spec)}"
          DeployToKubernetes.run jobSpec: deploy_job_spec

        end

        # send the webhook
        webhooks = GetWebhooksByBuildHistoryID.run build_history_id: build_result['buildID']
        webhooks.each do |webhook|
          payload = build_result
          payload.delete('logs')
          payload['createdAt'] = Time.now
          parsed_image_name = D2HUB::WebhookHelper.parse_image_name(payload['dockerImageName'])
          payload.delete('dockerImageName')
          payload['imageName'] = parsed_image_name[:name]
          payload['imageTag'] = parsed_image_name[:tag]
          DeliverWebhookPayload.run webhook_id: webhook[:id],
                                    payload: JSON.pretty_generate(payload)
        end
      else
        EditBuildHistory.run id: build_result['buildID'],
                             status: 'error',
                             error_reason: build_result['errorReason'],
                             docker_image_name: build_result['dockerImageName'],
                             logs: build_result['logs']
      end


      status 200
    end
  end
end