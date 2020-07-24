class RenameM3ProfileProperties < ActiveRecord::Migration[5.1]
  def change
    remove_index :m3_profile_properties, :allinson_flex_profile_id
    rename_table :m3_profile_properties, :allinson_flex_profile_properties
    add_index :allinson_flex_profile_properties, :allinson_flex_profile_id, name: :allinson_flex_properties_profile_id

    remove_index :allinson_flex_available_properties, :m3_profile_property_id
    rename_column :allinson_flex_available_properties, :m3_profile_property_id, :allinson_flex_profile_property_id
    add_index :allinson_flex_available_properties, :allinson_flex_profile_property_id, name: :allinson_flex_available_properties_property_id

    remove_index :m3_profile_texts, :m3_profile_property_id
    rename_column :m3_profile_texts, :m3_profile_property_id, :allinson_flex_profile_property_id
    add_index :m3_profile_texts, :allinson_flex_profile_property_id, name: :allinson_flex_profile_texts_on_profile_property_id
  end
end
