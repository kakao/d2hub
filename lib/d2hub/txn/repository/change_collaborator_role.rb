require_relative '../transaction'
require_relative '../repository/get'

module D2HUB
  class ChangeCollaboratorRoleOfRepository < Transaction
    def run(org_name: nil, repo_name: nil, user_name: nil, role: nil)
      repo = GetRepository.run org_name: org_name,
                               repo_name: repo_name
      user = User.find name: user_name
      DB[:collaborators].where(user_id: user[:id], repository_id: repo[:id]).update(role: role)
    end
  end
end