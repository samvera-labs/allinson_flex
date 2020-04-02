class CreateM3ProfileContexts < ActiveRecord::Migration[5.1]
  def change
    create_table :m3_profile_contexts, id: :integer do |t|
      t.string :name
      t.string :display_label
      t.references :m3_profile, type: :integer

      t.timestamps
    end
  end
end
