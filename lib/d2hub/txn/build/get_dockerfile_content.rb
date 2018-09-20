require_relative '../transaction'
require_relative '../repository'

module D2HUB
  class GetDockerfileContent < Transaction
    def run(github_client: nil,
            org_name: nil,
            repo_name: nil,
            dockerfile_location: nil,
            dockerfile_name: nil,
            git_branch_name: nil
    )
      begin
        unless github_client.nil?
          repo = GetRepository.run org_name: org_name, repo_name: repo_name
          dockerfile_location = '/' if (dockerfile_location.nil? or dockerfile_location == '')
          dockerfile_name = 'Dockerfile' if (dockerfile_name.nil? or dockerfile_name == '')
          response = github_client.contents(repo.github_repo_id, path: "#{dockerfile_location}/#{dockerfile_name}", ref: git_branch_name)
          return Base64.decode64(response.content) unless response.content.nil?
        end
      rescue Exception => e
        print e
      end
      ''
    end
  end
end