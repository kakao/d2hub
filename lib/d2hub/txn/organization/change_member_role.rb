require_relative '../transaction'

module D2HUB
  class ChangeMemberRoleOfOrganization < Transaction
    def run(org_name: nil, user_name: nil, role: nil)
      org = Organization.find name: org_name
      user = User.find name: user_name
      DB[:members].where(user_id: user[:id], organization_id: org[:id]).update(role: role)
    end
  end
end