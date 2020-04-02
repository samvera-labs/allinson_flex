class CreateM3ProfileClasses < ActiveRecord::Migration[5.1]
  def change
    create_table :m3_profile_classes, id: :integer do |t|
      t.string :name
      t.string :display_label
      t.string :schema_uri
      t.references :m3_profile, type: :integer

      t.timestamps
    end
  end
end
