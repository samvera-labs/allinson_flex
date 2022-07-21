class CreateAllinsonFlexProfileContexts < ActiveRecord::Migration[5.1]
  def change
    unless table_exists?(:allinson_flex_profile_contexts)
    create_table :allinson_flex_profile_contexts, id: :integer do |t|
      t.string :name
      t.string :display_label
      t.references :profile, type: :integer

      t.timestamps
    end
  end
end
