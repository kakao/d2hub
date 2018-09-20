require_relative '../transaction'

module D2HUB
  class GetGitHubRepo < Transaction
    def run(github_client: nil,
            github_repo_id: nil)
      return nil if github_client.nil?
      github_client.repo(github_repo_id)
    end
  end
end