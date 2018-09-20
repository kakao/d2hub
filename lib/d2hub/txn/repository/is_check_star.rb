require_relative '../transaction'

module D2HUB
  class IsCheckStarOfRepository < Transaction
    def run(user_name: nil, org_name: nil, repo_name: nil)
      user = User.find name: user_name
      repo = GetRepository.run org_name: org_name, repo_name: repo_name
      DB[:stars].filter(user_id: user[:id], repository_id: repo[:id]).count >= 1
    end
  end
end