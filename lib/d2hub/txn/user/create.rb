require_relative '../transaction'

module D2HUB
  class CreateUser < Transaction
    def run(user_name: nil)
      user = User.create name: user_name
      org = user.add_organization name: D2HUB::valid_org_name(user_name),
                                  type: 'main'
      DB[:members].where(user_id: user[:id], organization_id: org[:id]).update(role: 'owner')
      User[user[:id]]
    end
  end
end