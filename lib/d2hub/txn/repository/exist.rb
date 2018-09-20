require_relative '../transaction'

module D2HUB
  class ExistRepository < Transaction
    def run(org_name: nil, repo_name: nil)
      not GetRepository.run(org_name: org_name, repo_name: repo_name).nil?
    end
  end
end