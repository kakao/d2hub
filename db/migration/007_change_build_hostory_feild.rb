Sequel.migration do
  change do
    set_column_type :build_histories, :logs, String, size: 16777215
  end
end