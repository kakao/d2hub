require_relative '../transaction'
require_relative '../repository'
require_relative '../user'
require 'rest-client'

module D2HUB
  class DockerImageBuildStart < Transaction
    def run(user_name: nil, build_spec: nil)
      STDERR.puts "[image build] username : #{user_name} , buildspec : #{build_spec}"
      build_spec[:dockerTagName] = build_spec[:dockerTagName].gsub('/', '--')

      repo = GetRepository.run org_name: build_spec[:dockerOrgName],
                               repo_name: build_spec[:dockerRepoName]
      return nil if repo.nil?

      github_client = D2HUB::create_github_client_by_username github_host: repo.github_host,
                                                              user_name: user_name
      dockerfile_content = GetDockerfileContent.run github_client: github_client,
                                                    org_name: build_spec[:dockerOrgName],
                                                    repo_name: build_spec[:dockerRepoName],
                                                    dockerfile_location: build_spec[:dockerfileLocation],
                                                    dockerfile_name: build_spec[:dockerfileName],
                                                    git_branch_name: build_spec[:gitBranchName]

      build_history = AddBuildHistory.run org_name: build_spec[:dockerOrgName],
                                          repo_name: build_spec[:dockerRepoName],
                                          build_tag_id: build_spec[:buildTagID],
                                          git_url: "https://#{build_spec[:githubHost]}/#{build_spec[:githubOrgName]}/#{build_spec[:githubRepoName]}",
                                          git_type: build_spec[:gitBranchType],
                                          git_branch_name: build_spec[:gitBranchName],
                                          status: 'building',
                                          dockerfile_content: dockerfile_content,
                                          dockerfile_location: build_spec[:dockerfileLocation],
                                          dockerfile_name: build_spec[:dockerfileName],
                                          docker_tag_name: build_spec[:dockerTagName],
                                          dockerbuild_arg: build_spec[:dockerbuildArg],
                                          logs: ''
      build_spec[:buildID] = build_history[:id].to_s
      STDERR.puts "[image build] build history : #{build_history}"
      rest_client = RestClient::Resource.new(ENV['DOCKER_BUILDER_URL'], timeout: 3, open_timeout: 3)
      rest_client.post(build_spec.to_json, content_type: :json, accept: :json)
    end
  end
end