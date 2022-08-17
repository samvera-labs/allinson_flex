class CreateAllinsonFlexProfileClasses < ActiveRecord::Migration[5.1]
  def change
    unless table_exists?(:allinson_flex_profile_classes)
      create_table :allinson_flex_profile_classes, id: :integer do |t|
        t.string :name
        t.string :display_label
        t.string :schema_uri
        t.references :profile, type: :integer

        t.timestamps
      end
    end
  end
end
