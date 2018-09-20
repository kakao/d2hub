require_relative '../transaction'
require_relative '../repository/get'

module D2HUB
  class UncheckStarToRepository < Transaction
    def run(user_name: nil, org_name: nil, repo_name: nil)
      user = User.find name: user_name
      repo = GetRepository.run org_name: org_name, repo_name: repo_name
      user.remove_starred_repository repo
    end
  end
end