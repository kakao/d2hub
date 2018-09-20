require_relative '../transaction'
require_relative '../organization/get_members'

module D2HUB
  class GetOwnerOfOrganization < Transaction
    def run(org_name: nil)
      members = GetMembersOfOrganization.run org_name: org_name
      members.select do |user|
        user[:role] == 'owner'
      end.first
    end
  end
end