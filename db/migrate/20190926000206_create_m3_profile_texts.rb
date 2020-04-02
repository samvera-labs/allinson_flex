class CreateM3ProfileTexts < ActiveRecord::Migration[5.1]
  def change
    create_table :m3_profile_texts, id: :integer do |t|
      t.string :name
      t.string :value
      t.references :m3_profile_property, type: :integer
    end
  end
end
