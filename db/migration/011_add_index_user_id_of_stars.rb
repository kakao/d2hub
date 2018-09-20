Sequel.migration do
  change do
    add_index :stars, :user_id
  end
end
