class RenameM3ProfileTexts < ActiveRecord::Migration[5.1]
  def change
    rename_table :dynamic_schemas, :flexible_metadata_dynamic_schemas
  end
end
