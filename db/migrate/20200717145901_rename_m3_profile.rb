class RenameM3Profile < ActiveRecord::Migration[5.1]
  def change
    rename_table :m3_profiles, :allinson_flex_profiles
    
    remove_index :dynamic_schemas, :m3_profile_id
    rename_column :dynamic_schemas, :m3_profile_id, :allinson_flex_profile_id
    add_index :dynamic_schemas, :allinson_flex_profile_id, name: :allinson_flex_dynamic_schema_profile_id

    remove_index :allinson_flex_contexts, :m3_profile_id
    rename_column :allinson_flex_contexts, :m3_profile_id, :allinson_flex_profile_id
    add_index :allinson_flex_contexts, :allinson_flex_profile_id, name: :allinson_flex_context_profile_id

    remove_index :m3_profile_classes, :m3_profile_id
    rename_column :m3_profile_classes, :m3_profile_id, :allinson_flex_profile_id
    add_index :m3_profile_classes, :allinson_flex_profile_id

    remove_index :m3_profile_contexts, :m3_profile_id
    rename_column :m3_profile_contexts, :m3_profile_id, :allinson_flex_profile_id
    add_index :m3_profile_contexts, :allinson_flex_profile_id

    remove_index :m3_profile_properties, :m3_profile_id
    rename_column :m3_profile_properties, :m3_profile_id, :allinson_flex_profile_id
    add_index :m3_profile_properties, :allinson_flex_profile_id
  end
end
