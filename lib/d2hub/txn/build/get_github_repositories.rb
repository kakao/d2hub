require_relative '../transaction'

module D2HUB
  class GetGitHubRepositories < Transaction
    def run(github_host: nil, user_name: nil)
      gh_client = D2HUB::create_github_client_by_username github_host: github_host,
                                                          user_name: user_name
      return nil if gh_client.nil?

      gh_client.repos
      # gh_repos = [gh_client.repos]
      # gh_repos.push(gh_client.orgs.map do |org|
      #                 gh_client.org_repos org.login
      #               end).flatten!
      # gh_repos
    end
  end
end