require_relative '../transaction'
require_relative '../repository'

module D2HUB
  class GetRepoInfoByBuildTag < Transaction
    def run(build_tag_id: nil)
      build_tag = BuildTag.first id: build_tag_id
      repo = Repository.first(id: build_tag.repository_id)
      org = Organization.first(id: repo.organization_id)
      {org: org, repo: repo}
    end
  end
end
