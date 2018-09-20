Sequel.migration do
  change do
    add_column :build_histories, :docker_image_name, String, text: true
  end
end
