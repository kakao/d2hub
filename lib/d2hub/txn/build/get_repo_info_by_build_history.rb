require_relative '../transaction'
require_relative '../repository'

module D2HUB
  class GetRepoInfoByBuildHistory < Transaction
    def run(build_history_id: nil)
      build_history = GetBuildHistory.run id: build_history_id
      repo = Repository.first(id: build_history.repository_id)
      org = Organization.first(id: repo.organization_id)
      {org: org, repo: repo}
    end
  end
end