require_relative '../transaction'
require 'rest-client'

module D2HUB
  class DeployToMarathon < Transaction
    def run(payload: nil, auth: nil)
      begin
        req_args = {
            method: :post,
            url: "#{ENV['CHRONOS_URL']}/scheduler/iso8601",
            payload: payload,
            headers: {content_type: :json}
        }
        unless auth.nil? and auth != ''
          auth_info = auth.split(':')
          req_args[:user] = auth_info[0]
          req_args[:password] = auth_info[1]
        end
        response = RestClient::Request.execute req_args
      rescue Exception => e
        STDERR.print(e)
      else
        STDERR.print(response)
      end
    end
  end
end
