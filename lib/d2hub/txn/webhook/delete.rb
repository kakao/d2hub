require_relative '../transaction'

module D2HUB
  class DeleteWebhook < Transaction
    def run(webhook_id: nil)
      Webhook[webhook_id].destroy
    end
  end
end
