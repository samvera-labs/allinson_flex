class RenameM3ProfileClasses < ActiveRecord::Migration[5.1]
  def change
    remove_index :m3_profile_classes, :flexible_metadata_profile_id
    rename_table :m3_profile_classes, :flexible_metadata_profile_classes
    add_index :flexible_metadata_profile_classes, :flexible_metadata_profile_id, name: :flexible_metadata_classes_profile_id
    
    remove_index :m3_profile_classes_contexts, :m3_profile_class_id
    rename_column :m3_profile_classes_contexts, :m3_profile_class_id, :flexible_metadata_profile_class_id
    add_index :m3_profile_classes_contexts, :flexible_metadata_profile_class_id, name: :flexible_metadata_profile_classes_id
  end
end