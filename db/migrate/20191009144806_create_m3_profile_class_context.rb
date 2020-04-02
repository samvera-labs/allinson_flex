class CreateM3ProfileClassContext < ActiveRecord::Migration[5.1]
  def change
    create_table :m3_profile_classes_contexts, id: :integer do |t|
      t.belongs_to :m3_profile_context
      t.belongs_to :m3_profile_class

      t.timestamps
    end
  end
end
