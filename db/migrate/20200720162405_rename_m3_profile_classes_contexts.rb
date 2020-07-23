class RenameM3ProfileClassesContexts < ActiveRecord::Migration[5.1]
  def change
    remove_index :m3_profile_classes_contexts, :flexible_metadata_profile_class_id
    remove_index :m3_profile_classes_contexts, :flexible_metadata_profile_context_id
    rename_table :m3_profile_classes_contexts, :flexible_metadata_profile_classes_contexts
    add_index :flexible_metadata_profile_classes_contexts, :flexible_metadata_profile_class_id, name: :flexible_metadata_profile_classes_id
    add_index :flexible_metadata_profile_classes_contexts, :flexible_metadata_profile_context_id, name: :flexible_metadata_profile_contexts_id
  end
end