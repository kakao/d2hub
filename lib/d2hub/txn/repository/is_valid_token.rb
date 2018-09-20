require_relative '../transaction'
require_relative '../repository/get'
require_relative '../user/get'

module D2HUB
  class IsValidPushKeyOfRepository < Transaction
    def run(org_name: nil, repo_name: nil, push_key_id: nil, push_key_password: nil)
      repo = GetRepository.run org_name: org_name,
                               repo_name: repo_name
      return false if repo.nil?
      repo[:push_key_id] == push_key_id
      repo[:push_key_password] == push_key_password
    end
  end
end