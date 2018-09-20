require 'sinatra/base'
require 'haml'
require 'rest-client'
require_relative '../txn'
require_relative 'register'

module D2HUB
  class RepositoryController < D2hubBase
    register ControllerRegister

    get '/repos' do
      @repos = GetAllRepositories.run count: nil
      haml :all_list_repo
    end

    get '/repo/add' do
      @orgs = GetOrganizations.run user_name: user_id
      @error = params[:error]
      @org_name = params[:org_name] || D2HUB::valid_org_name(user_id)
      haml :add_repo
    end

    get '/orgs/:org_name/repos/:repo_name' do |org_name, repo_name|
      @repo = GetRepository.run org_name: org_name,
                                repo_name: repo_name
      @is_check_star = IsCheckStarOfRepository.run user_name: user_id,
                                                   org_name: org_name,
                                                   repo_name: repo_name
      @comments = GetComments.run org_name: org_name,
                                  repo_name: repo_name

      unless @repo.build_tags.empty?
        dockerfile_location = @repo.build_tags[0].dockerfile_location
        dockerfile_name = @repo.build_tags[0].dockerfile_name
        git_branch_name = @repo.build_tags[0].git_branch_name
        dockerbuild_arg = @repo.build_tags[0].dockerbuild_arg
        build_tag = @repo.build_tags.find do |build_tag|
          not build_tag.use_regex
        end
        if build_tag.nil?
          git_branch_name = 'master'
        else
          dockerfile_location = build_tag.dockerfile_location
          git_branch_name = build_tag.git_branch_name
        end

        github_client = D2HUB::create_github_client_by_username github_host: @repo.github_host,
                                                                user_name: user_id
        @dockerfile_content = GetDockerfileContent.run github_client: github_client,
                                                       org_name: org_name,
                                                       repo_name: repo_name,
                                                       dockerfile_location: dockerfile_location,
                                                       dockerfile_name: dockerfile_name,
                                                       git_branch_name: git_branch_name
        @github_address =
            GetGitHubAddress.run github_client: github_client,
                                               github_repo_id: @repo.github_repo_id
        @build_histories = GetBuildHistories.run org_name: org_name, repo_name: repo_name
      end

      @error = params[:error]
      haml :layout_repo do
        haml :detail_repo
      end
    end

    get '/orgs/:org_name/repos/:repo_name/settings' do |org_name, repo_name|
      @repo = GetRepository.run org_name: org_name,
                                repo_name: repo_name
      @is_check_star = IsCheckStarOfRepository.run user_name: user_id,
                                                   org_name: org_name,
                                                   repo_name: repo_name
      haml :layout_repo do
        haml :detail_repo
      end
    end

    get '/orgs/:org_name/repos' do |org_name|
      @user = GetOwnerOfOrganization.run org_name: org_name
      @orgs = GetOrganizations.run user_name: @user[:name]
      @repos = GetRepositories.run org_name: org_name
      @org_name = org_name
      haml :layout_main  do
        haml :list_repo do
          haml :_add_repo_btn
        end
      end
    end

    get '/orgs/:org_name/repos/:repo_name/edit/profile' do |org_name, repo_name|
      @repo = GetRepository.run org_name: org_name,
                                repo_name: repo_name
      @is_check_star = IsCheckStarOfRepository.run user_name: user_id,
                                                   org_name: org_name,
                                                   repo_name: repo_name
      haml :layout_repo do
        haml :edit_repo_profile
      end
    end

    get '/orgs/:org_name/repos/:repo_name/collabors' do |org_name, repo_name|
      @repo = GetRepository.run org_name: org_name,
                                repo_name: repo_name
      @is_check_star = IsCheckStarOfRepository.run user_name: user_id,
                                                   org_name: org_name,
                                                   repo_name: repo_name
      @collaborators = GetCollaboratorsFromRepository.run org_name: org_name,
                                                          repo_name: repo_name
      @error = params[:error]

      haml :layout_repo do
        haml :edit_repo_collabor
      end
    end

    get '/orgs/:org_name/repos/:repo_name/pushkeys' do |org_name, repo_name|
      @repo = GetRepository.run org_name: org_name,
                                repo_name: repo_name
      @is_check_star = IsCheckStarOfRepository.run user_name: user_id,
                                                   org_name: org_name,
                                                   repo_name: repo_name
      haml :layout_repo do
        haml :edit_repo_pushkey
      end
    end

    get '/orgs/:org_name/repos/:repo_name/automated_builds' do |org_name, repo_name|
      @repo = GetRepository.run org_name: org_name,
                                repo_name: repo_name

      github_client = D2HUB::create_github_client_by_username github_host: @repo.github_host,
                                                              user_name: user_id
      gh_repo = GetGitHubRepo.run github_client: github_client,
                                  github_repo_id: @repo.github_repo_id

      @github_repo_full_name = ''
      @github_repo_full_name = gh_repo.full_name unless gh_repo.nil?

      haml :layout_repo do
        @error = params[:error]
        haml :edit_automated_build
      end
    end

    get '/orgs/:org_name/repos/:repo_name/marathon_deploy' do |org_name, repo_name|
      @error = params[:error]
      @repo = GetRepository.run org_name: org_name,
                                repo_name: repo_name

      haml :layout_repo do
        haml :edit_marathon_deploy
      end
    end

    get '/orgs/:org_name/repos/:repo_name/kubernetes_deploy' do |org_name, repo_name|
      @error = params[:error]
      @repo = GetRepository.run org_name: org_name,
                                repo_name: repo_name

      haml :layout_repo do
        haml :edit_kubernetes_deploy
      end
    end

    get '/api/orgs/:org_name/repos/:repo_name/tags' do |org_name, repo_name|
      tags = GetTagsOfRepository.run org_name: org_name,
                                     repo_name: repo_name

      [200, JSON.generate(tags)]
    end

    get '/api/orgs/:org_name/repos/:repo_name/build_tags/:build_tag_id/marathon_deploys' do |org_name, repo_name, build_tag_id|
      marathon_deploys = GetMarathonDeploys.run build_tag_id: build_tag_id
      [200, JSON.generate(marathon_deploys)]
    end

    post '/api/orgs/:org_name/repos/:repo_name/build_tags/:build_tag_id/marathon_deploys' do |org_name, repo_name, build_tag_id|
      marathon_deploy = CreateMarathonDeploy.run build_tag_id: build_tag_id,
                                                 marathon_url: params[:marathon_url],
                                                 marathon_basic_auth: params[:marathon_basic_auth],
                                                 marathon_json_path: params[:marathon_json_path],
                                                 env_vars: params[:env_vars],
                                                 label_vars: params[:label_vars]
      [201, JSON.generate(marathon_deploy)]
    end

    put '/api/orgs/:org_name/repos/:repo_name/build_tags/:build_tag_id/marathon_deploys/:marathon_deploy_id' do |org_name, repo_name, build_tag_id, marathon_deploy_id|
      UpdateMarathonDeploy.run marathon_deploy_id: marathon_deploy_id,
                               marathon_basic_auth: params[:marathon_basic_auth],
                               marathon_url: params[:marathon_url],
                               marathon_json_path: params[:marathon_json_path],
                               env_vars: params[:env_vars],
                               label_vars: params[:label_vars]
      status 204
    end

    delete '/api/orgs/:org_name/repos/:repo_name/build_tags/:build_tag_id/marathon_deploys/:marathon_deploy_id' do |org_name, repo_name, build_tag_id, marathon_deploy_id|
      DeleteMarathonDeploy.run marathon_deploy_id: marathon_deploy_id
      status 204
    end

    get '/api/orgs/:org_name/repos/:repo_name/build_tags/:build_tag_id/kubernetes_deploys' do |org_name, repo_name, build_tag_id|
      kubernetes_deploys = GetKubernetesDeploys.run build_tag_id: build_tag_id
      [200, JSON.generate(kubernetes_deploys)]
    end

    post '/api/orgs/:org_name/repos/:repo_name/build_tags/:build_tag_id/kubernetes_deploys' do |org_name, repo_name, build_tag_id|
      kubernetes_deploy = CreateKubernetesDeploy.run build_tag_id: build_tag_id,
                                                 kubernetes_url: params[:kubernetes_url],
                                                 kubernetes_kubeconfig: params[:kubernetes_kubeconfig],
                                                 kubernetes_yaml_path: params[:kubernetes_yaml_path],
                                                 env_vars: params[:env_vars]
      [201, JSON.generate(kubernetes_deploy)]
    end

    put '/api/orgs/:org_name/repos/:repo_name/build_tags/:build_tag_id/kubernetes_deploys/:kubernetes_deploy_id' do |org_name, repo_name, build_tag_id, kubernetes_deploy_id|
      UpdateKubernetesDeploy.run kubernetes_deploy_id: kubernetes_deploy_id,
                               kubernetes_kubeconfig: params[:kubernetes_kubeconfig],
                               kubernetes_url: params[:kubernetes_url],
                               kubernetes_yaml_path: params[:kubernetes_yaml_path],
                               env_vars: params[:env_vars]
      status 204
    end

    delete '/api/orgs/:org_name/repos/:repo_name/build_tags/:build_tag_id/kubernetes_deploys/:kubernetes_deploy_id' do |org_name, repo_name, build_tag_id, kubernetes_deploy_id|
      DeleteKubernetesDeploy.run kubernetes_deploy_id: kubernetes_deploy_id
      status 204
    end

    get '/orgs/:org_name/repos/:repo_name/webhooks' do |org_name, repo_name|
      @error = params[:error]
      @repo = GetRepository.run org_name: org_name,
                                repo_name: repo_name

      @webhooks = GetWebhooks.run org_name: org_name,
                                  repo_name: repo_name


      haml :layout_repo do
        haml :edit_webhook
      end
    end

    get '/orgs/:org_name/repos/:repo_name/webhooks' do |org_name, repo_name|
      @error = params[:error]
      @repo = GetRepository.run org_name: org_name,
                                repo_name: repo_name

      @webhooks = GetWebhooks.run org_name: org_name,
                                  repo_name: repo_name


      haml :layout_repo do
        haml :edit_webhook
      end
    end

    get '/orgs/:org_name/repos/:repo_name/webhooks/:webhook_id/payloads' do |org_name, repo_name, webhook_id|
      @repo = GetRepository.run org_name: org_name,
                                repo_name: repo_name

      @webhook = GetWebhook.run webhook_id: webhook_id
      @webhook_payloads = GetWebhookPayloads.run webhook_id: webhook_id

      haml :layout_repo do
        haml :list_webhook_payloads
      end
    end

    get '/api/orgs/:org_name/repos/:repo_name/build_tags' do |org_name, repo_name|
      build_tags = GetBuildTags.run org_name: org_name, repo_name: repo_name
      [200, JSON.generate(build_tags)]
    end

    get '/api/orgs/:org_name/repos/:repo_name/build_tags/:build_tag_id' do |org_name, repo_name, build_tag_id|
      build_tag = BuildTag.find id: build_tag_id
      [200, JSON.generate(build_tag)]
    end

    post '/orgs/:org_name/repos/:repo_name/pushkeys' do |org_name, repo_name|
      redirect URI(back).path if params[:push_key_id] == '' or params[:push_key_password] == ''
      RegistPushKeyOfRepository.run org_name: org_name,
                                    repo_name: repo_name,
                                    push_key_id: params[:push_key_id],
                                    push_key_password: params[:push_key_password]
      redirect URI(back).path
    end

    post '/repos' do
      redirect to("#{URI(back).path}?error=dismiss_required_fields") if params['org_name'] == '' or params['repo_name'] == ''
      repo_name_length = params['repo_name'].length
      redirect to("#{URI(back).path}?error=invalid_repo_name") if (/^[\.a-z0-9_-]+$/ =~ params['repo_name']).nil? or (repo_name_length < 3) or (30 < repo_name_length)

      build_tags = nil
      build_tags = JSON.parse(params[:build_tags]) if params[:build_tags]

      redirect to("#{URI(back).path}?error=already_exists") if ExistRepository.run org_name: params['org_name'], repo_name: params['repo_name']
      new_repo = CreateRepository.run user_name: user_id,
                                      org_name: params['org_name'],
                                      repo_name: params['repo_name'],
                                      short_description: params['short_description'],
                                      description: params['description'],
                                      access_type: params['access_type'],
                                      github_host: params['github_host'],
                                      github_repo_id: params['github_repo_id'].to_i,
                                      build_tags: build_tags,
                                      active_build: params['active_build'],
                                      watch_center_id: params['watch_center_id']
      redirect to("#{URI(back).path}?error=creating_repo_failed") if new_repo.nil?
      redirect "/users/#{user_id}"
    end

    post '/orgs/:org_name/repos/:repo_name/star' do |org_name, repo_name|
      is_check_star = IsCheckStarOfRepository.run user_name: user_id,
                                                  org_name: org_name,
                                                  repo_name: repo_name
      CheckStarToRepository.run user_name: user_id,
                                org_name: org_name,
                                repo_name: repo_name unless is_check_star
      status 204
    end

    delete '/orgs/:org_name/repos/:repo_name/star' do |org_name, repo_name|
      is_check_star = IsCheckStarOfRepository.run user_name: user_id,
                                                  org_name: org_name,
                                                  repo_name: repo_name
      UncheckStarToRepository.run user_name: user_id,
                                  org_name: org_name,
                                  repo_name: repo_name if is_check_star
      status 200
    end

    put '/orgs/:org_name/repos/:repo_name' do |org_name, repo_name|
      options = {
          org_name: org_name,
          repo_name: repo_name
      }
      options[:short_description] = params[:short_description] if params[:short_description]
      options[:description] = params[:description] if params[:description]
      options[:access_type] = params[:access_type] if params[:access_type]
      options[:active_build] = (params[:active_build] == 'on') if params[:active_build]
      options[:build_tags] = nil
      options[:build_tags] = JSON.parse(params[:build_tags]) if params[:build_tags]
      options[:watch_center_id] = params[:watch_center_id] if params[:watch_center_id]

      options[:build_tags].each {
        |build_tag| next if build_tag['dockerbuild_arg'].empty?
        begin
          JSON.parse(build_tag['dockerbuild_arg'])
        rescue
          redirect to("#{URI(back).path}?error=invalidbuildarg")
        end
      } unless options[:build_tags].nil?

      EditRepository.run options

      request.xhr? ? (status 200) : (redirect "orgs/#{org_name}/repos/#{repo_name}")
    end

    delete '/orgs/:org_name/repos/:repo_name' do |org_name, repo_name|
      halt 401 unless has_authority_of_repository? org_name, repo_name
      result = DeleteRepository.run org_name: org_name, repo_name: repo_name
      result.nil? ? (status 400) : (status 200)
    end

    post '/orgs/:org_name/repos/:repo_name/collaborators' do |org_name, repo_name|
      unless ExistUser.run user_name: params[:user_name]
        if AuthController.exist? params[:user_name]
          CreateUser.run user_name: params[:user_name]
        else
          redirect to("#{URI(back).path}?error=not_exists")
        end
      end
      result = AddCollaboratorToRepository.run org_name: org_name,
                                               repo_name: repo_name,
                                               user_name: params[:user_name]
      redirect to("#{URI(back).path}?error=already_exists") if result.nil?
      redirect URI(back).path
    end

    delete '/orgs/:org_name/repos/:repo_name/collaborators/:user_name' do |org_name, repo_name, user_name|
      redirect to("#{URI(back).path}?error=delete_failed") unless ExistUser.run user_name: params[:user_name]
      RemoveCollaboratorFromRepository.run org_name: org_name,
                                           repo_name: repo_name,
                                           user_name: user_name
      redirect URI(back).path
    end

    delete '/orgs/:org_name/repos/:repo_name/tags/:tag_name' do |org_name, repo_name, tag_name|
      halt 401 unless has_authority_of_repository? org_name, repo_name
      # halt 401 if tag_name == "latest"
      status_code = RemoveImageFromRepository.run org_name: org_name,
                                                repo_name: repo_name,
                                                tag_name: tag_name
      status status_code
    end


    post '/orgs/:org_name/repos/:repo_name/webhooks' do |org_name, repo_name|
      redirect to("#{URI(back).path}?error=empty_url") if params[:webhook_url] == ''
      redirect to("#{URI(back).path}?error=invalid_auth") if params[:webhook_auth] != '' and params[:webhook_auth].count(':') != 1

      result = CreateWebhook.run org_name: org_name,
                                 repo_name: repo_name,
                                 webhook_url: params[:webhook_url],
                                 webhook_auth: params[:webhook_auth]
      redirect to("#{URI(back).path}?error=create_failed") if result.nil?
      redirect URI(back).path
    end

    delete '/orgs/:org_name/repos/:repo_name/webhooks/:webhook_id' do |org_name, repo_name, webhook_id|
      result = DeleteWebhook.run webhook_id: webhook_id
      redirect to("#{URI(back).path}?error=delete_failed") if result.nil?
      redirect URI(back).path
    end
  end
end