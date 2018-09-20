require 'json'

module D2HUB
  class GetDrscanTag
    def self.run(org_name: nil, repo_name: nil, tag_name: nil)
      repo = GetRepository.run org_name: org_name, repo_name: repo_name
      DrscanTag.find(repository_id: repo.id, name: tag_name)
    end
  end
end