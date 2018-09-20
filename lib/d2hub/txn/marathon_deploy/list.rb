require_relative '../transaction'
require_relative '../build'

module D2HUB
  class GetMarathonDeploys < Transaction
    def run(build_tag_id: nil)
      MarathonDeploy.where(build_tag_id: build_tag_id).all
    end
  end
end
