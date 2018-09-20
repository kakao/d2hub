require_relative '../transaction'

module D2HUB
  class EditWebhookURL < Transaction
    def run(webhook_id: nil, webhook_url: nil)
      Webhook.where(id: webhook_id).update(url: webhook_url)
    end
  end
end
