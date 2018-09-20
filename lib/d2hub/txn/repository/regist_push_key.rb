require_relative '../transaction'
require_relative '../repository/get'
# require 'rubysl/securerandom'

module D2HUB
  class RegistPushKeyOfRepository < Transaction
    def run(org_name: nil, repo_name: nil, push_key_id: nil, push_key_password: nil)
      repo = GetRepository.run org_name: org_name,
                               repo_name: repo_name
      repo.update push_key_id: push_key_id,
                  push_key_password: push_key_password
      Repository[repo[:id]]
    end
  end
end