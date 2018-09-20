Sequel.migration do
  change do
      add_column :repositories, :push_key_id, String
      add_column :repositories, :push_key_password, String
  end
end