Sequel.migration do
  change do
    add_column :repositories, :github_access_token, String, text: true
  end
end