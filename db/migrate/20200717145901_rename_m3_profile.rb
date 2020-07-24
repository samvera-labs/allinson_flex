class RenameM3Profile < ActiveRecord::Migration[5.1]
  def change
    rename_table :m3_profiles, :flexible_metadata_profiles
    
    remove_index :dynamic_schemas, :m3_profile_id
    rename_column :dynamic_schemas, :m3_profile_id, :flexible_metadata_profile_id
    add_index :dynamic_schemas, :flexible_metadata_profile_id, name: :flexible_metadata_dynamic_schema_profile_id

    remove_index :flexible_metadata_contexts, :m3_profile_id
    rename_column :flexible_metadata_contexts, :m3_profile_id, :flexible_metadata_profile_id
    add_index :flexible_metadata_contexts, :flexible_metadata_profile_id, name: :flexible_metadata_context_profile_id

    remove_index :m3_profile_classes, :m3_profile_id
    rename_column :m3_profile_classes, :m3_profile_id, :flexible_metadata_profile_id
    add_index :m3_profile_classes, :flexible_metadata_profile_id

    remove_index :m3_profile_contexts, :m3_profile_id
    rename_column :m3_profile_contexts, :m3_profile_id, :flexible_metadata_profile_id
    add_index :m3_profile_contexts, :flexible_metadata_profile_id

    remove_index :m3_profile_properties, :m3_profile_id
    rename_column :m3_profile_properties, :m3_profile_id, :flexible_metadata_profile_id
    add_index :m3_profile_properties, :flexible_metadata_profile_id
  end
end
