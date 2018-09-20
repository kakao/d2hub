require_relative '../transaction'
require_relative '../repository'

module D2HUB
  class CreateWebhook < Transaction
    def run(org_name: nil, repo_name: nil, webhook_url: nil, webhook_auth: nil)
      repo = GetRepository.run org_name: org_name,
                               repo_name: repo_name
      repo.add_webhook url: webhook_url,
                       auth: webhook_auth
    end
  end
end
