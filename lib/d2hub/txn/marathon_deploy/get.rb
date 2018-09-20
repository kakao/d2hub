require_relative '../transaction'

module D2HUB
  class GetMarathonDeploy < Transaction
    def run(marathon_deploy_id: nil)
      MarathonDeploy.find id: marathon_deploy_id
    end
  end
end
