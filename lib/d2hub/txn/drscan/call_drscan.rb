require_relative '../transaction'
require 'rest-client'

module D2HUB
  class CallDrScan < Transaction
    def run(base_url: nil,
            org_name: nil,
            repo_name: nil,
            tag_name: nil)
      begin
        req_args = {
            method: :post,
            url: "#{ENV['DRSCAN_URL']}/",
            payload: {
                baseUrl: base_url,
                imgName: "#{D2HUB::full_repo_name(org_name, repo_name)}",
                tag: tag_name
            }.to_json,
            headers: {
                content_type: :json,
                appept: :json
            }
        }
        resp = RestClient::Request.execute req_args
        resp.code == 201
      rescue Exception => e
        STDERR.print(e)
        false
      end
    end
  end
end
