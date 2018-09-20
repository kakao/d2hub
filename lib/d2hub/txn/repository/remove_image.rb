require_relative '../transaction'

module D2HUB
  class RemoveImageFromRepository < Transaction
    @@logger = Logger.new(STDOUT)
    def run(org_name: nil, repo_name: nil, tag_name: nil)
      url = D2HUB::admin_organization?(org_name) ?
                "#{ENV['API_DOCKER_REGISTRY_URL']}/v2/#{repo_name}/manifests/" :
                "#{ENV['API_DOCKER_REGISTRY_URL']}/v2/#{org_name}/#{repo_name}/manifests/"

      # get digest
      resource = RestClient::Resource.new(
          url+tag_name,
          user: ENV['API_DOCKER_REGISTRY_USERNAME'],
          password: ENV['API_DOCKER_REGISTRY_PASSWORD'],
          timeout: 3,
          open_timeout: 3
      )
      response = resource.get(:Accept => "application/vnd.docker.distribution.manifest.v2+json")
      digest = response.headers[:"docker_content_digest"]

      # delete digest
      resource = RestClient::Resource.new(
          url+digest,
          user: ENV['API_DOCKER_REGISTRY_USERNAME'],
          password: ENV['API_DOCKER_REGISTRY_PASSWORD'],
          timeout: 3,
          open_timeout: 3
      )
      @@logger.info("DeleteImage org:#{org_name}, repo:#{repo_name}, tag:#{tag_name}")
      response = resource.delete(:Accept => "application/vnd.docker.distribution.manifest.v2+json")

    rescue
      @@logger.info("DeleteImage Failed org:#{org_name}, repo:#{repo_name}, tag:#{tag_name}")
      400
    end
  end
end
