require_relative '../transaction'

module D2HUB
  class IsMemberOfOrganization < Transaction
    def run(org_name: nil, user_name: nil)
      org = Organization.find name: org_name
      user = User.find name: user_name
      DB[:members].where(user_id: user[:id], organization_id: org[:id]).count > 0
    end
  end
end