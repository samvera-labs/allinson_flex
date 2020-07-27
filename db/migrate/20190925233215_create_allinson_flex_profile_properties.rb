class CreateAllinsonFlexProfileProperties < ActiveRecord::Migration[5.1]
  def change
    create_table :allinson_flex_profile_properties, id: :integer do |t|
      t.string :name
      t.string :property_uri
      t.integer :cardinality_minimum, default: 0
      t.integer :cardinality_maximum, default: 100
      t.string :indexing
      t.references :profile, index: { name: 'index_profile_properties_on_profile_id' }, type: :integer

      t.timestamps
    end
  end
end
