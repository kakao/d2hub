require 'json'

module D2HUB
  class ListDrscanTagsMap
    def self.run(org_name: nil, repo_name: nil)
      begin
        resp = RestClient.get("#{ENV['DRSCAN_URL']}/tags?imgName=#{D2HUB::full_repo_name(org_name, repo_name)}")
        if resp.code == 200
          result = JSON.parse(resp.body)
          result['tags'].group_by do |tag|
            tag['tag']
          end
        end
      rescue Exception => e
        STDERR.puts e
        {}
      end
    end
  end
end