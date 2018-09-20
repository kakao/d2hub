require_relative '../transaction'

module D2HUB
  class GetRepositoriesByGitHubRepoId < Transaction
    def run(github_repo_id: nil)
      Repository.where(github_repo_id: github_repo_id).all
    end
  end
end