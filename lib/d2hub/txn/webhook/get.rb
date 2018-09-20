require_relative '../transaction'

module D2HUB
  class GetWebhook < Transaction
    def run(webhook_id: nil)
      Webhook.find id: webhook_id
    end
  end
end
