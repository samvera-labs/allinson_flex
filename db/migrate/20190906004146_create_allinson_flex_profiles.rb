class CreateAllinsonFlexProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :allinson_flex_profiles, id: :integer do |t|
      t.string :name
      t.float :profile_version # version in m3
      t.string :m3_version
      t.string :responsibility
      t.string :responsibility_statement
      t.string :date_modified
      t.string :profile_type
      t.text :profile, limit: 3000000

      t.timestamps
    end
  end
end
