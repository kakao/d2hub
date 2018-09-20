Sequel.migration do
  change do
    create_table :drscan_tags do
      primary_key :id
      String :name, null: false, default: ''
      String :ticket_id, null: false, default: ''
      Integer :repository_id, null: false
      DateTime :updated_at
      DateTime :created_at
    end
  end
end
