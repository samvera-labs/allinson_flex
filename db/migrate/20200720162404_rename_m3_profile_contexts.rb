class RenameM3ProfileContexts < ActiveRecord::Migration[5.1]
  def change
    remove_index :m3_profile_contexts, :allinson_flex_profile_id
    rename_table :m3_profile_contexts, :allinson_flex_profile_contexts
    add_index :allinson_flex_profile_contexts, :allinson_flex_profile_id, name: :allinson_flex_contexts_profile_id
    
    remove_index :m3_profile_classes_contexts, :m3_profile_context_id
    rename_column :m3_profile_classes_contexts, :m3_profile_context_id, :allinson_flex_profile_context_id
    add_index :m3_profile_classes_contexts, :allinson_flex_profile_context_id, name: :allinson_flex_profile_contexts_id

    remove_index :allinson_flex_contexts, :m3_profile_context_id
    rename_column :allinson_flex_contexts, :m3_profile_context_id, :allinson_flex_profile_context_id
    add_index :allinson_flex_contexts, :allinson_flex_profile_context_id, name: :allinson_flex_contexts_id
  end
end
