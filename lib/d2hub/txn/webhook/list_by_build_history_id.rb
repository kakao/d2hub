require_relative '../transaction'
require_relative '../repository'
require_relative '../build'

module D2HUB
  class GetWebhooksByBuildHistoryID < Transaction
    def run(build_history_id: nil)
      build_history = GetBuildHistory.run id: build_history_id
      Webhook.where(repository_id: build_history[:repository_id]).all
    end
  end
end


