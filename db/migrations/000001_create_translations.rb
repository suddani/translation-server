Sequel.migration do
  up do
    create_table(:translations) do
      primary_key :id
      String :project, null: false
      String :lang, null: false
      String :namespace, null: false
      String :key, null: false
      String :hint, null: false
      Boolean :active, default: false
      String :version
      String :value
    end
  end

  down do
    drop_table(:translations)
  end
end