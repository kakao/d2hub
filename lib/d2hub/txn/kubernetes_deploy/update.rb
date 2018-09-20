require_relative '../transaction'

module D2HUB
  class UpdateKubernetesDeploy < Transaction
    def run(kubernetes_deploy_id: nil,
            kubernetes_url: nil,
            kubernetes_kubeconfig: nil,
            kubernetes_yaml_path: nil,
            env_vars: nil)
      KubernetesDeploy.where(id: kubernetes_deploy_id).update(
          kubernetes_url: kubernetes_url,
          kubernetes_kubeconfig: kubernetes_kubeconfig,
          kubernetes_yaml_path: kubernetes_yaml_path,
          env_vars: env_vars)
    end
  end
end
