class AddTextableToProfileTexts < ActiveRecord::Migration[5.1]
  def change
    add_reference :allinson_flex_profile_texts, :textable, index: { name: 'index_profile_texts_on_type_and_id' }, polymorphic: true unless column_exists?(:allinson_flex_profile_texts, :textable_type)
  end
end
