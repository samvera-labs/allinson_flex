class RenameM3ProfileProperties < ActiveRecord::Migration[5.1]
  def change
    remove_index :m3_profile_properties, :flexible_metadata_profile_id
    rename_table :m3_profile_properties, :flexible_metadata_profile_properties
    add_index :flexible_metadata_profile_properties, :flexible_metadata_profile_id, name: :flexible_metadata_properties_profile_id

    remove_index :flexible_metadata_available_properties, :m3_profile_property_id
    rename_column :flexible_metadata_available_properties, :m3_profile_property_id, :flexible_metadata_profile_property_id
    add_index :flexible_metadata_available_properties, :flexible_metadata_profile_property_id, name: :flexible_metadata_available_properties_property_id

    remove_index :m3_profile_texts, :m3_profile_property_id
    rename_column :m3_profile_texts, :m3_profile_property_id, :flexible_metadata_profile_property_id
    add_index :m3_profile_texts, :flexible_metadata_profile_property_id, name: :flexible_metadata_profile_texts_on_profile_property_id
  end
end
