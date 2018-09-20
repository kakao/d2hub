require_relative '../transaction'
require_relative '../repository/get'
require_relative '../user/get'

module D2HUB
  class IsCollaboratorOfRepository < Transaction
    def run(org_name: nil, repo_name: nil, user_name: nil)
      repo = GetRepository.run org_name: org_name,
                               repo_name: repo_name
      user = GetUser.run user_name: user_name
      DB[:collaborators].filter(repository_id: repo[:id], user_id: user[:id]).count > 0
    end
  end
end