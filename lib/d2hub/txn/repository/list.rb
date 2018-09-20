require_relative '../transaction'

module D2HUB
  class GetRepositories < Transaction
    def run(org_name: nil)
      org = Organization.find name: org_name
      org.repositories_dataset.order(:updated_at, :created_at).reverse.all
    end
  end
end