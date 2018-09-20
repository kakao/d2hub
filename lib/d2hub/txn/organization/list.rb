require_relative '../transaction'

module D2HUB
  class GetOrganizations < Transaction
    def run(user_name: nil)
      user = User.find name: user_name
      Organization.join(:members, organization_id: :id).where(user_id: user[:id]).all
    end
  end
end