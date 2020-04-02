class CreateM3ProfileProperties < ActiveRecord::Migration[5.1]
  def change
    create_table :m3_profile_properties, id: :integer do |t|
      t.string :name
      t.string :property_uri
      t.integer :cardinality_minimum, default: 0
      t.integer :cardinality_maximum, default: 100
      t.string :indexing
      t.references :m3_profile, type: :integer

      t.timestamps
    end
  end
end
