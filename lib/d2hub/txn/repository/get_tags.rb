require 'rest-client'
require 'json'

module D2HUB
  class GetTagsOfRepository
    def self.run(org_name: nil, repo_name: nil)
      url = D2HUB::admin_organization?(org_name) ?
          "#{ENV['API_DOCKER_REGISTRY_URL']}/v2#{repo_name}/tags/list" :
          "#{ENV['API_DOCKER_REGISTRY_URL']}/v2/#{org_name}/#{repo_name}/tags/list"
      resource = RestClient::Resource.new(
          url,
          user: ENV['API_DOCKER_REGISTRY_USERNAME'],
          password: ENV['API_DOCKER_REGISTRY_PASSWORD'],
          timeout: 3,
          open_timeout: 3
      )
      response = resource.get accept: :json
      tags = JSON.parse(response)['tags']
      return [] if tags.nil?

      drscan_tags_map = ListDrscanTagsMap.run org_name: org_name,
                                              repo_name: repo_name
      tags.map do |tag_name|
        result = {
            name: tag_name,
            av_detect_cnt: 0,
            clair_detect_cnt: 0,
            ticket_id: '',
            status: 0
        }
        if drscan_tags_map.key?(tag_name)
          tag = drscan_tags_map[tag_name][0]
          result[:ticket_id] = tag['ticketId']
          result[:status] = tag['status_code']
          if tag['status_code'] == 1 && (not tag['data'].nil?)
            result[:av_detect_cnt] = tag['data']['av']['detectCnt']
            result[:clair_detect_cnt] = (tag['data']['clair']['defconCnt'] + tag['data']['clair']['criticalCnt'])
          end
        end
        result
      end
    rescue Exception => e
      STDERR.puts e
      []
    end
  end
end