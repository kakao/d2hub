require_relative '../transaction'

module D2HUB
  class InsertGitHubAccessToken < Transaction
    def run(user_name: nil, github_host: nil, access_token: nil)
      user = GetUser.run user_name: user_name

      D2HUB::github_hosts.each do |key, value|
        if github_host == value[:host]
          if key.include? 'kakaocorp'
            user.update kakaocorp_github_access_token: access_token
          else
            user.update github_access_token: access_token
          end
        end
      end
    end
  end
end