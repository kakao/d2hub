require_relative '../transaction'

module D2HUB
  class IsMainTypeOrganization < Transaction
    def run(org_name: nil)
      org = Organization.find name: org_name
      org[:type] == 'main'
    end
  end
end