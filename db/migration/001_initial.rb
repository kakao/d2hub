Sequel.migration do
  change do
    create_table :users do
      primary_key :id
      String :name, size: 50, null: false, unique: true

      index [:name]
    end

    create_table :repositories do
      primary_key :id
      String :name, size: 50, null: false
      String :short_description, text: true, null: false, default: ''
      String :description, text: true, null: false, default: ''
      String :access_type, null: false, default: 'public' # 'public' or 'private'
      Integer :organization_id, null: false
      Integer :download_count, default: 0
      DateTime :updated_at
      DateTime :created_at

      index [:name]
      index [:access_type]
    end

    create_table :organizations do
      primary_key :id
      String :name, size: 50, null: false, unique: true
      String :description, text: true, null: false, default: ''
      String :type, null: false, default: 'sub' # 'main' or 'sub'
      DateTime :updated_at
      DateTime :created_at

      index [:name]
    end

    create_table :active_feeds do
      primary_key :id
      String :action, text: true, null: false
      Integer :user_id, null: false
      DateTime :updated_at
      DateTime :created_at
    end

    create_table :comments do
      primary_key :id
      Integer :user_id, null: false
      Integer :repository_id, null: false
      String :contents, text: true, null: false, default: ''
      DateTime :updated_at
      DateTime :created_at
    end

    create_table :collaborators do
      Integer :user_id, null: false
      Integer :repository_id, null: false
      String :role, null: false, default: 'collaborator' # 'owner' or 'collaborator'

      primary_key %i[user_id repository_id]
    end

    create_table :members do
      Integer :user_id, null: false
      Integer :organization_id, null: false
      String :role, null: false, default: 'member' # 'owner' or 'member'

      primary_key %i[user_id organization_id]
    end

    create_table :stars do
      Integer :user_id, null: false
      Integer :repository_id, null: false

      primary_key %i[user_id repository_id]
    end
  end
end