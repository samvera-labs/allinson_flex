class AddAvailableOnToAllinsonFlexProfileAvailableProperty < ActiveRecord::Migration[5.1]
  def change
    add_reference :allinson_flex_profile_available_properties, :available_on, polymorphic: true, index: { name: 'index_allinson_flex_profile_properties_available_on' } unless column_exists?(:allinson_flex_profile_available_properties, :available_on_type)
  end
end
