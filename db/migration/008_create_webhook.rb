Sequel.migration do
  change do
    create_table :webhooks do
      primary_key :id
      String :url, text: true, null: false, default: ''
      String :auth, text: true, null: false, default: ''
      Integer :repository_id, null: false
      DateTime :updated_at
      DateTime :created_at
    end

    create_table :webhook_payloads do
      primary_key :id
      String :payload, text: true, null: false, default: ''
      Integer :response_code, null: false
      String :response_headers, text: true, null: false, default: ''
      String :response_body, text: true, null: false, default: ''
      Integer :webhook_id, null: false
      DateTime :updated_at
      DateTime :created_at
    end
  end
end
