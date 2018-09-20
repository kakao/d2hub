Sequel.migration do
  change do
    add_column :users, :kakaocorp_github_access_token, String, text: true
  end
end