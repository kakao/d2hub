require_relative '../transaction'

module D2HUB
  class ExistOrganization < Transaction
    def run(org_name: nil)
      not Organization.find(name: org_name).nil?
    end
  end
end