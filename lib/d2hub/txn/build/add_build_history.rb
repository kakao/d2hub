require_relative '../transaction'
require_relative '../repository'

module D2HUB
  class AddBuildHistory < Transaction
    def run(org_name: nil,
            repo_name: nil,
            build_tag_id: nil,
            git_url: nil,
            git_type: nil,
            git_branch_name: nil,
            status: nil,
            dockerfile_content: nil,
            dockerfile_location: nil,
            dockerfile_name: nil,
            docker_tag_name: nil,
            dockerbuild_arg: nil,
            logs: nil)
      dockerfile_location = '/' if dockerfile_location.nil?
      dockerfile_name = 'Dockerfile' if dockerfile_name.nil?
      dockerbuild_arg = '' if dockerbuild_arg.nil?
      repo = GetRepository.run org_name: org_name, repo_name: repo_name
      repo.add_build_history build_tag_id: build_tag_id,
                             git_url: git_url,
                             git_type: git_type,
                             git_branch_name: git_branch_name,
                             status: status,
                             dockerfile_content: dockerfile_content,
                             dockerfile_location: dockerfile_location,
                             dockerfile_name: dockerfile_name,
                             docker_tag_name: docker_tag_name,
                             dockerbuild_arg: dockerbuild_arg,
                             logs: logs
    end
  end
end