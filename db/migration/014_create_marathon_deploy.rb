Sequel.migration do
  change do
    create_table :marathon_deploys do
      primary_key :id
      String :marathon_url, text: true, null: false, default: ''
      String :marathon_basic_auth, text: true, null: false, default: ''
      String :marathon_json_path, text: true, null: false, default: ''
      String :env_vars, text: true, null: false, default: ''
      String :label_vars, text: true, null: false, default: ''
      Integer :build_tag_id, null: false
      DateTime :updated_at
      DateTime :created_at
    end
  end
end
