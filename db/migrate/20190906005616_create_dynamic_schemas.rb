class CreateDynamicSchemas < ActiveRecord::Migration[5.1]
  def change
    create_table :dynamic_schemas, id: :integer do |t|
      t.string :flexible_metadata_class
      t.references :flexible_metadata_context, type: :integer
      t.references :m3_profile, type: :integer
      t.text :schema, limit: 3000000

      t.timestamps
    end
  end
end
