require_relative '../transaction'

module D2HUB
  class GetGitHubAddress < Transaction
    def run(github_client: nil,
            github_repo_id: nil)
      gh_repo = GetGitHubRepo.run github_client: github_client,
                                  github_repo_id: github_repo_id
      return '' if gh_repo.nil?
      "#{gh_repo['html_url']}"
    end
  end
end