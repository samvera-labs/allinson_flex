class AddRequirementToAllinsonFlexProfileProperties < ActiveRecord::Migration[5.2]
  def change
    add_column :allinson_flex_profile_properties, :requirement, :string, default: "optional", null: false unless column_exists?(:allinson_flex_profile_available_properties, :requirement)
  end
end
