class CreateAllinsonFlexContexts < ActiveRecord::Migration[5.1]
  def change
    create_table :allinson_flex_contexts, id: :integer do |t|
      t.string :name
      t.string :admin_set_ids
      t.string :m3_context_name
      t.references :profile, type: :integer
      t.references :profile_context, type: :integer

      t.timestamps
    end
  end
end
