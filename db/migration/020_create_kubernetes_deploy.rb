Sequel.migration do
  change do
    create_table :kubernetes_deploys do
      primary_key :id
      String :kubernetes_url, text: true, null: false, default: ''
      String :kubernetes_kubeconfig, text: true, null: false, default: ''
      String :kubernetes_yaml_path, text: true, null: false, default: ''
      String :env_vars, text: true, null: false, default: ''
      Integer :build_tag_id, null: false
      DateTime :updated_at
      DateTime :created_at
    end
  end
end
