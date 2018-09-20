require_relative '../transaction'
require_relative '../repository'

module D2HUB
  class DockerImageBuildManually < Transaction
    def run(user_name: nil, build_tag_id: nil)
      STDERR.puts "[manually build] username : #{user_name} , build_tag_id : #{build_tag_id}"
      build_tag = BuildTag.first(id: build_tag_id)
      return nil if build_tag.use_regex

      repo = Repository.first(id: build_tag.repository_id)
      raise 'not found the repository' if repo.nil?
      STDERR.puts "[manually build] repo : #{repo.values}"

      github_access_token = D2HUB::get_github_access_token github_host: repo.github_host,
                                                           user_name: user_name
      raise 'not found the github access token' if github_access_token.nil?
      STDERR.puts "[manually build] github access token : #{github_access_token}"

      gh_client = D2HUB::create_github_client_by_token github_host: repo.github_host,
                                                       github_access_token: github_access_token
      raise 'not found the github client' if gh_client.nil?

      gh_repo = gh_client.repo repo.github_repo_id

      gh_org_name = gh_repo.full_name.split('/')[0]
      gh_repo_name = gh_repo.name

      build_spec = {
          username: 'd2hub',
          buildTagID: build_tag.id,
          githubHost: repo.github_host,
          githubOrgName: gh_org_name,
          githubRepoName: gh_repo_name,
          githubToken: github_access_token,
          gitBranchType: build_tag.git_type,
          gitBranchName: build_tag.git_branch_name,
          dockerfileLocation: build_tag.dockerfile_location,
          dockerfileName: build_tag.dockerfile_name,
          dockerbuildArg: build_tag.dockerbuild_arg,
          dockerTagName: build_tag.docker_tag_name,
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