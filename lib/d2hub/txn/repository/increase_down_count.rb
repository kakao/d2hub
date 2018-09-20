require_relative '../transaction'
require_relative 'get'

module D2HUB
  class IncreaseDownCountOfRepository < Transaction
    def run(org_name: nil, repo_name: nil)
      repo = GetRepository.run org_name: org_name, repo_name: repo_name
      repo.update download_count: Sequel.+(:download_count, 1)
    end
  end
end