class CreateAllinsonFlexDynamicSchemas < ActiveRecord::Migration[5.1]
  def change
    create_table :allinson_flex_dynamic_schemas, id: :integer do |t|
      t.string :allinson_flex_class
      t.references :context, type: :integer
      t.references :profile, type: :integer
      t.text :schema, limit: 3000000

      t.timestamps
    end
  end
end
