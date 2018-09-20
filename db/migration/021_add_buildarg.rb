Sequel.migration do
  change do
    add_column :build_tags, :dockerbuild_arg, String, text: true, default: ''
    add_column :build_histories, :dockerbuild_arg, String, text: true, default: ''
  end
end