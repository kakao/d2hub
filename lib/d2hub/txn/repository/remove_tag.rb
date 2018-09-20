require_relative '../transaction'

module D2HUB
  class RemoveTagFromRepository < Transaction
    def run(org_name: nil, repo_name: nil, tag_name: nil)
      url = D2HUB::admin_organization?(org_name) ?
          "#{ENV['API_DOCKER_REGISTRY_URL']}/v1/repositories/#{repo_name}/tags/#{tag_name}" :
          "#{ENV['API_DOCKER_REGISTRY_URL']}/v1/repositories/#{org_name}/#{repo_name}/tags/#{tag_name}"
      resource = RestClient::Resource.new(url, timeout: 3, open_timeout: 3)
      response = resource.delete
      response.code
    rescue
      400
    end
  end
end