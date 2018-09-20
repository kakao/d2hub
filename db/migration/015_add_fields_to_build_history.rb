Sequel.migration do
  change do
    add_column :build_histories, :build_tag_id, Integer
  end
end