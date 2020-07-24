class RenameM3ProfileTexts < ActiveRecord::Migration[5.1]
  def change
    remove_index :m3_profile_texts, :flexible_metadata_profile_property_id
    remove_index :m3_profile_texts, [:textable_type, :textable_id]
    rename_table :m3_profile_texts, :flexible_metadata_profile_texts
    add_index :flexible_metadata_profile_texts, :flexible_metadata_profile_property_id, name: :flexible_metadata_profile_texts_property_id
    add_index :flexible_metadata_profile_texts, [:textable_type, :textable_id], name: :textable_type_and_textable_id
  end
end