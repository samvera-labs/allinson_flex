class CreateAllinsonFlexProfileTexts < ActiveRecord::Migration[5.1]
  def change
    create_table :allinson_flex_profile_texts, id: :integer do |t|
      t.string :name
      t.string :value
      t.references :profile_property, index: { name: 'index_profile_texts_on_profile_property_id' }, type: :integer
    end
  end
end
