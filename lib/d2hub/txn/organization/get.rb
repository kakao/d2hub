require_relative '../transaction'

module D2HUB
  class GetOrganization < Transaction
    def run(org_name: nil)
      Organization.find name: org_name
    end
  end
end