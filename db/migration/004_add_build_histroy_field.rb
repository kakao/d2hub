Sequel.migration do
  change do
    add_column :build_histories, :error_reason, String, text: true
  end
end
