Sequel.migration do
  change do
    add_index :drscan_tags, [:repository_id, :name]
  end
end