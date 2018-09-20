require_relative '../transaction'

module D2HUB
  class DeleteKubernetesDeploy < Transaction
    def run(kubernetes_deploy_id: nil)
      KubernetesDeploy[kubernetes_deploy_id].destroy
    end
  end
end
