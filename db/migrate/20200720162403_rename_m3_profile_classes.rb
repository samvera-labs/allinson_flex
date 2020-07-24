class RenameM3ProfileClasses < ActiveRecord::Migration[5.1]
  def change
    remove_index :m3_profile_classes, :allinson_flex_profile_id
    rename_table :m3_profile_classes, :allinson_flex_profile_classes
    add_index :allinson_flex_profile_classes, :allinson_flex_profile_id, name: :allinson_flex_classes_profile_id
    
    remove_index :m3_profile_classes_contexts, :m3_profile_class_id
    rename_column :m3_profile_classes_contexts, :m3_profile_class_id, :allinson_flex_profile_class_id
    add_index :m3_profile_classes_contexts, :allinson_flex_profile_class_id, name: :allinson_flex_profile_classes_id
  end
end
