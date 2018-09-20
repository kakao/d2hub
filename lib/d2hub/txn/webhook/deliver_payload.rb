require_relative '../transaction'
require 'rest-client'

module D2HUB
  class DeliverWebhookPayload < Transaction
    def run(webhook_id: nil, payload: nil)
      webhook = Webhook.find id: webhook_id
      begin
        req_args = {
            method: :post,
            url: webhook[:url],
            payload: payload,
            headers: {content_type: :json}
        }
        if webhook[:auth] != ''
          auth_info = webhook[:auth].split(':')
          req_args[:user] = auth_info[0]
          req_args[:password] = auth_info[1]
        end
        response = RestClient::Request.execute req_args
      rescue Exception => e
        webhook.add_webhook_payload payload: payload,
                                    response_code: 404
      else
        webhook.add_webhook_payload payload: payload,
                                    response_code: response.code,
                                    response_headers: response.headers.to_json,
                                    response_body: response.body
      end
    end
  end
end
