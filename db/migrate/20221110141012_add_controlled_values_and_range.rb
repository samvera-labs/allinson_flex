class AddControlledValuesAndRange < ActiveRecord::Migration[5.2]
  def change
    add_column :allinson_flex_profile_properties, :controlled_value_sources, :string unless column_exists?(:allinson_flex_profile_properties, :controlled_value_sources)
    add_column :allinson_flex_profile_properties, :range, :string unless column_exists?(:allinson_flex_profile_properties, :range)
  end
end
