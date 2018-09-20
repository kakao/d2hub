require_relative '../transaction'
require_relative '../build'

module D2HUB
  class GetKubernetesDeploys < Transaction
    def run(build_tag_id: nil)
      KubernetesDeploy.where(build_tag_id: build_tag_id).all
    end
  end
end
