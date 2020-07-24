class RenameM3ProfileContexts < ActiveRecord::Migration[5.1]
  def change
    remove_index :m3_profile_contexts, :flexible_metadata_profile_id
    rename_table :m3_profile_contexts, :flexible_metadata_profile_contexts
    add_index :flexible_metadata_profile_contexts, :flexible_metadata_profile_id, name: :flexible_metadata_contexts_profile_id
    
    remove_index :m3_profile_classes_contexts, :m3_profile_context_id
    rename_column :m3_profile_classes_contexts, :m3_profile_context_id, :flexible_metadata_profile_context_id
    add_index :m3_profile_classes_contexts, :flexible_metadata_profile_context_id, name: :flexible_metadata_profile_contexts_id

    remove_index :flexible_metadata_contexts, :m3_profile_context_id
    rename_column :flexible_metadata_contexts, :m3_profile_context_id, :flexible_metadata_profile_context_id
    add_index :flexible_metadata_contexts, :flexible_metadata_profile_context_id, name: :flexible_metadata_contexts_id
  end
end