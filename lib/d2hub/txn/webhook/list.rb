require_relative '../transaction'
require_relative '../repository'

module D2HUB
  class GetWebhooks < Transaction
    def run(org_name: nil, repo_name: nil)
      repo = GetRepository.run org_name: org_name, repo_name: repo_name
      Webhook.where(repository_id: repo[:id]).all
    end
  end
end
