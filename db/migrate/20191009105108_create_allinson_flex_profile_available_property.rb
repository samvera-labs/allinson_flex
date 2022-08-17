class CreateAllinsonFlexProfileAvailableProperty < ActiveRecord::Migration[5.1]
  def change
    unless table_exists?(:allinson_flex_profile_available_properties)
      create_table :allinson_flex_profile_available_properties, id: :integer do |t|
        t.references :profile_property, index: { name: 'index_available_properties_on_property_id' }, type: :integer
        t.timestamps
      end
    end
  end
end
