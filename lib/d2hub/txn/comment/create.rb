require_relative '../transaction'
require_relative '../repository/get'

module D2HUB
  class CreateComment < Transaction
    def run(org_name: nil, repo_name: nil, user_name: nil, contents: nil)
      repo = GetRepository.run org_name: org_name,
                               repo_name: repo_name
      user = User.find name: user_name
      Comment.create user_id: user[:id],
                     repository_id: repo[:id],
                     contents: contents
    end
  end
end