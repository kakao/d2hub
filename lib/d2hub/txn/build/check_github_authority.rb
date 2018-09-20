require_relative '../transaction'

module D2HUB
  class CheckGitHubAuthority < Transaction
    def run(github_host: nil, user_name: nil)
      gh_client = D2HUB::create_github_client_by_username github_host: github_host,
                                                          user_name: user_name
      (not gh_client.nil?)
    end
  end
end