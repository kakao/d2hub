require_relative '../transaction'

module D2HUB
  class CreateOrganization < Transaction
    def run(user_name: nil, org_name: nil, description: nil, type: nil)
      user = User.find name: user_name
      exist_org = ExistOrganization.run org_name: org_name

      if exist_org
        owner = GetOwnerOfOrganization.run(org_name: org_name)
        if owner[:id] == user[:id]
          return Organization.find name: org_name
        else
          return nil
        end
      else
        org_data = {name: org_name}
        org_data[:description] = description unless description.nil?
        org_data[:type] = type unless type.nil?
        org = user.add_organization org_data
        DB[:members].where(user_id: user[:id], organization_id: org[:id]).update(role: 'owner')
        Organization[org[:id]]
      end
    end
  end
end