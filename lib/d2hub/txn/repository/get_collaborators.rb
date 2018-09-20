require_relative '../transaction'
require_relative '../repository/get'

module D2HUB
  class GetCollaboratorsFromRepository < Transaction
    def run(org_name: nil, repo_name: nil)
      repo = GetRepository.run org_name: org_name,
                               repo_name: repo_name

      role_hash = DB[:collaborators].filter(repository_id: repo[:id]).to_hash(:user_id, :role)
      repo.users.map do |user|
        new_user = user.clone
        new_user[:role] = role_hash[user.id]
        new_user
      end
    end
  end
end