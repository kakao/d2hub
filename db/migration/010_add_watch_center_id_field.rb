Sequel.migration do
  change do
    add_column :repositories, :watch_center_id, String, text: true, default: ''
  end
end