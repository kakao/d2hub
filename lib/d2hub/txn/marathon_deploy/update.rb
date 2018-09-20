require_relative '../transaction'

module D2HUB
  class UpdateMarathonDeploy < Transaction
    def run(marathon_deploy_id: nil,
            marathon_url: nil,
            marathon_basic_auth: nil,
            marathon_json_path: nil,
            env_vars: nil,
            label_vars: nil)
      MarathonDeploy.where(id: marathon_deploy_id).update(
          marathon_url: marathon_url,
          marathon_basic_auth: marathon_basic_auth,
          marathon_json_path: marathon_json_path,
          env_vars: env_vars,
          label_vars: label_vars)
    end
  end
end
