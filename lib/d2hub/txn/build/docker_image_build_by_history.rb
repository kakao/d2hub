require_relative '../transaction'
require_relative '../repository'

module D2HUB
  class DockerImageBuildByHistory < Transaction
    def run(user_name: nil, build_history_id: nil)
      build_history = GetBuildHistory.run id: build_history_id
      raise 'not found the build history' if build_history.nil?

      repo = Repository.first(id: build_history.repository_id)
      raise 'not found the repository' if repo.nil?

      github_access_token = D2HUB::get_github_access_token github_host: repo.github_host,
                                                           user_name: user_name
      raise 'not found the github access token' if github_access_token.nil?

      gh_client = D2HUB::create_github_client_by_token github_host: repo.github_host,
                                                       github_access_token: github_access_token
      raise 'not found the github client' if gh_client.nil?

      gh_repo = gh_client.repo repo.github_repo_id

      gh_org_name = gh_repo.full_name.split('/')[0]
      gh_repo_name = gh_repo.name

      build_spec = {
          username: user_name,
          buildTagID: build_history.build_tag_id,
          githubHost: repo.github_host,
          githubOrgName: gh_org_name,
          githubRepoName: gh_repo_name,
          githubToken: github_access_token,
          gitBranchType: build_history.git_type,
          gitBranchName: build_history.git_branch_name,
          dockerfileLocation: build_history.dockerfile_location,
          dockerfileName: build_history.dockerfile_name,
          dockerbuildArg: build_history.dockerbuild_arg,
          dockerTagName: build_history.docker_tag_name,
          dockerOrgName: repo.organization[:name],
          dockerRepoName: repo.name,
          d2hubPushKeyID: repo.push_key_id,
          d2hubPushKeyPassword: repo.push_key_password,
          watchCenterID: repo.watch_center_id,
          resultCallbackURL: ENV['DOCKER_BUILD_RESULT_URL']
      }
      DockerImageBuildStart.run user_name: user_name,
                                build_spec: build_spec
    end
  end
end