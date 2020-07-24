class RenameM3ProfileAvailableProperties < ActiveRecord::Migration[5.1]
  def change
    rename_table :m3_profile_available_properties, :flexible_metadata_available_properties

  end
end
