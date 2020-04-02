class CreateM3Contexts < ActiveRecord::Migration[5.1]
  def change
    create_table :flexible_metadata_contexts, id: :integer do |t|
      t.string :name
      t.string :admin_set_ids
      t.string :flexible_metadata_context_name
      t.references :m3_profile, type: :integer
      t.references :m3_profile_context, type: :integer

      t.timestamps
    end
  end
end
