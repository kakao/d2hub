require_relative '../transaction'

module D2HUB
  class DeleteMarathonDeploy < Transaction
    def run(marathon_deploy_id: nil)
      MarathonDeploy[marathon_deploy_id].destroy
    end
  end
end
