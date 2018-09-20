require_relative '../transaction'

module D2HUB
  class GetMembersOfOrganization < Transaction
    def run(org_name: nil)
      org = Organization.find name: org_name
      role_hash = DB[:members].filter(organization_id: org[:id]).to_hash(:user_id, :role)
      org.users.map do |user|
        user[:role] = role_hash[user.id]
        user
      end
    end
  end
end