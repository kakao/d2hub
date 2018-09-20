Sequel.migration do
  change do
    add_column :repositories, :github_host, String, text: true, null: false, default: 'github.com'
  end
end