class RenameDynamicSchemas < ActiveRecord::Migration[5.1]
  def change
    remove_index :dynamic_schemas, :allinson_flex_context_id
    remove_index :dynamic_schemas, :allinson_flex_profile_id

    rename_table :dynamic_schemas, :allinson_flex_dynamic_schemas
    add_index :allinson_flex_dynamic_schemas, :allinson_flex_context_id, name: :allinson_flex_dynamic_schemas_context_id
    add_index :allinson_flex_dynamic_schemas, :allinson_flex_profile_id, name: :allinson_flex_dynamic_schemas_profile_id

  end
end
