require_relative '../transaction'
require_relative '../build'

module D2HUB
  class CreateKubernetesDeploy < Transaction
    def run(
        build_tag_id: nil,
        kubernetes_url: nil,
        kubernetes_kubeconfig: nil,
        kubernetes_yaml_path: nil,
        env_vars: nil
    )
      build_tag = BuildTag.find id: build_tag_id
      build_tag.add_kubernetes_deploy kubernetes_url: kubernetes_url,
                                    kubernetes_kubeconfig: kubernetes_kubeconfig,
                                    kubernetes_yaml_path: kubernetes_yaml_path,
                                    env_vars: env_vars
    end
  end
end
