require_relative '../transaction'

module D2HUB
  class GetRepository < Transaction
    def run(org_name: nil, repo_name: nil)
      org = Organization.find name: org_name
      org.repositories_dataset.first(name: repo_name)
    end
  end
end