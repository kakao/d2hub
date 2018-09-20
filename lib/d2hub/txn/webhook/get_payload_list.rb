require_relative '../transaction'

module D2HUB
  class GetWebhookPayloads < Transaction
    def run(webhook_id: nil)
      WebhookPayload.where(webhook_id: webhook_id).order(:created_at).reverse.all
    end
  end
end
