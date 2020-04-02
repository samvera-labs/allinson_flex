class AddTextableToM3ProfileTexts < ActiveRecord::Migration[5.1]
  def change
    add_reference :m3_profile_texts, :textable, polymorphic: true, index: true
  end
end
