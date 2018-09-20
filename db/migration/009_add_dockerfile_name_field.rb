Sequel.migration do
  change do
    add_column :build_tags, :dockerfile_name, String, text: true, default: 'Dockerfile'
    add_column :build_histories, :dockerfile_location, String, text: true, default: '/'
    add_column :build_histories, :dockerfile_name, String, text: true, default: 'Dockerfile'
  end
end