class RenameM3ProfileTexts < ActiveRecord::Migration[5.1]
  def change
    rename_table :dynamic_schemas, :allinson_flex_dynamic_schemas
  end
end
