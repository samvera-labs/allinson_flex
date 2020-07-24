class RenameM3ProfileAvailableProperties < ActiveRecord::Migration[5.1]
  def change
    rename_table :m3_profile_available_properties, :allinson_flex_profile_available_properties
  end
end
