require_relative '../transaction'
require_relative '../repository'
require_relative '../user'

module D2HUB
  class DockerImageBuildByPush < Transaction
    def run(gh_payload: nil)
      return nil if gh_payload['deleted']

      gh_repo_id = gh_payload['repository']['id']
      git_type, git_branch_name = D2HUB::parse_git_type_and_branch_name gh_ref: gh_payload['ref']
      STDERR.puts "[automated build] git_type: #{git_type}"
      STDERR.puts "[automated build] git_branch_name: #{git_branch_name}"
      return nil if git_type.nil?

      gh_full_name = gh_payload['repository']['full_name']
      gh_org_name = gh_full_name.split('/')[0]
      gh_repo_name = gh_payload['repository']['name']

      repos = GetRepositoriesByGitHubRepoId.run(github_repo_id: gh_repo_id).compact
      STDERR.puts "[automated build] repos.length: #{repos.length}"
      repos.each do |repo|
        STDERR.puts "[automated build] repo name: #{repo.name}"
        unless repo.active_build
          STDERR.puts "[automated build] disabled active build - name: #{gh_full_name}, type: #{git_type}, branch/tag: #{git_branch_name}"
          next
        end

        build_tags = FindBuildTags.run repo: repo, git_type: git_type, git_branch_name: git_branch_name
        if build_tags.nil?
          STDERR.puts "[automated build] not found build tag - name: #{gh_full_name}, type: #{git_type}, branch/tag: #{git_branch_name}"
          next
        end

        owner = GetOwnerOfRepository.run org_name: repo.organization[:name], repo_name: repo.name
        if owner.nil?
          STDERR.puts "[automated build] not found owner - name: #{gh_full_name}, type: #{git_type}, branch/tag: #{git_branch_name}"
          next
        end

        github_access_token = D2HUB::get_github_access_token github_host: repo.github_host,
                                                             user_name: owner[:name]
        if github_access_token.nil?
          STDERR.puts "[automated build] not found github access token - name: #{gh_full_name}, type: #{git_type}, branch/tag: #{git_branch_name}"
          next
        end

        STDERR.puts "[automated build] build_tags.length: #{build_tags.length}"
        build_tags.each do |build_tag|
          STDERR.puts "[automated build] build_tag: #{build_tag}"
          build_spec = {
              username: owner[:name],
              buildTagID: build_tag.id,
              githubHost: repo.github_host,
              githubOrgName: gh_org_name,
              githubRepoName: gh_repo_name,
              githubToken: github_access_token,
              gitBranchType: build_tag.git_type,
              gitBranchName: build_tag.git_branch_name,
              dockerfileLocation: build_tag.dockerfile_location,
              dockerfileName: build_tag.dockerfile_name,
              dockerTagName: build_tag.docker_tag_name,
              dockerOrgName: repo.organization[:name],
              dockerbuildArg: build_tag.dockerbuild_arg,
              dockerRepoName: repo.name,
              d2hubPushKeyID: repo.push_key_id,
              d2hubPushKeyPassword: repo.push_key_password,
              watchCenterID: repo.watch_center_id,
              resultCallbackURL: ENV['DOCKER_BUILD_RESULT_URL']
          }

          STDERR.puts "[automated build] spec: #{build_spec}"
          DockerImageBuildStart.run user_name: owner[:name],
                                    build_spec: build_spec
        end
      end
    end
  end
end