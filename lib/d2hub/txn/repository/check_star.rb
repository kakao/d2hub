require_relative '../transaction'

module D2HUB
  class CheckStarToRepository < Transaction
    def run(user_name: nil, org_name: nil, repo_name: nil)
      user = User.find name: user_name
      repo = GetRepository.run org_name: org_name, repo_name: repo_name
      user.add_starred_repository repo
    end
  end
end