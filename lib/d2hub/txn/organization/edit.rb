require_relative '../transaction'

module D2HUB
  class EditOrganization < Transaction
    def run(org_name: nil, description: nil)
      Organization.where(name: org_name).update(description: description)
    end
  end
end