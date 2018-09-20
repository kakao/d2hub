require_relative '../transaction'
require_relative '../repository/get_collaborators'

module D2HUB
  class GetOwnerOfRepository < Transaction
    def run(org_name: nil, repo_name: nil)
      collabors = GetCollaboratorsFromRepository.run org_name: org_name,
                                                     repo_name: repo_name
      collabors.select do |user|
        user[:role] == 'owner'
      end.first
    end
  end
end