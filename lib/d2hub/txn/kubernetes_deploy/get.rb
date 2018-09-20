require_relative '../transaction'

module D2HUB
  class GetKubernetesDeploy < Transaction
    def run(kubernetes_deploy_id: nil)
      KubernetesDeploy.find id: kubernetes_deploy_id
    end
  end
end
