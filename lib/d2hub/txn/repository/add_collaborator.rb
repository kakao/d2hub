require_relative '../transaction'
require_relative '../repository/get'

module D2HUB
  class AddCollaboratorToRepository < Transaction
    def run(org_name: nil, repo_name: nil, user_name: nil)
      repo = GetRepository.run org_name: org_name,
                               repo_name: repo_name
      user = User.find name: user_name
      repo.add_user user
    end
  end
end