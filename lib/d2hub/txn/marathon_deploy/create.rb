require_relative '../transaction'
require_relative '../build'

module D2HUB
  class CreateMarathonDeploy < Transaction
    def run(
        build_tag_id: nil,
        marathon_url: nil,
        marathon_basic_auth: nil,
        marathon_json_path: nil,
        env_vars: nil,
        label_vars: nil
    )
      build_tag = BuildTag.find id: build_tag_id
      build_tag.add_marathon_deploy marathon_url: marathon_url,
                                    marathon_basic_auth: marathon_basic_auth,
                                    marathon_json_path: marathon_json_path,
                                    env_vars: env_vars,
                                    label_vars: label_vars
    end
  end
end
