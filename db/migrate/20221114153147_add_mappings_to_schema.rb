class AddMappingsToSchema < ActiveRecord::Migration[5.2]
  def change
    add_column :allinson_flex_profile_properties, :mappings, :text unless column_exists?(:allinson_flex_profile_properties, :mappings)
  end
end
