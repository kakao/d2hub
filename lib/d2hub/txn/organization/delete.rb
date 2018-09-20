require_relative '../transaction'
require_relative '../user/get_owner_of_organization'

module D2HUB
  class DeleteOrganization < Transaction
    def run(org_name: nil)
      owner = GetOwnerOfOrganization.run org_name: org_name
      org = Organization.find name: org_name
      owner.remove_organization org
      org.destroy
    end
  end
end