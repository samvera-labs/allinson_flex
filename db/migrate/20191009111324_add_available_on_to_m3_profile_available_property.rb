class AddAvailableOnToM3ProfileAvailableProperty < ActiveRecord::Migration[5.1]
  def change
    add_reference :m3_profile_available_properties, :available_on, polymorphic: true, index: { name: 'index_m3_profile_properties_available_on' }
  end
end
