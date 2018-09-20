Sequel.migration do
  change do
    add_column :users, :github_access_token, String, text: true
    add_column :repositories, :github_repo_id, Integer
    add_column :repositories, :github_hook_id, Integer
    add_column :repositories, :active_build, FalseClass
    add_index :repositories, :github_repo_id

    create_table :build_tags do
      primary_key :id
      Integer :repository_id, null: false
      String :git_type, text: true, null: false
      String :git_branch_name, text: true, null: false
      String :dockerfile_location, text: true, null: false
      String :docker_tag_name, text: true, null: false
    end

    create_table :build_histories do
      primary_key :id
      Integer :repository_id, null: false
      String :git_url, text: true, null: false
      String :git_branch_name, text: true, null: false
      String :status, text: true, null: false # 'finished' or 'error'
      String :dockerfile_content, text: true, null: false
      String :logs, text: true, null: false
      DateTime :updated_at
      DateTime :created_at
    end
  end
end