Sequel.migration do
  change do
    add_column :build_histories, :git_type, String, text: true, null: false, default: ''
    add_column :build_histories, :docker_tag_name, String, text: true, null: false, default: ''
  end
end