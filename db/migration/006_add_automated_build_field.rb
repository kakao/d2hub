Sequel.migration do
  change do
    add_column :build_tags, :use_regex, FalseClass
  end
end