class CreateAllinsonFlexProfileClassContext < ActiveRecord::Migration[5.1]
  def change
    unless table_exists?(:allinson_flex_profile_classes_contexts)
    create_table :allinson_flex_profile_classes_contexts, id: :integer do |t|
      t.references :profile_context, index: { name: 'index_profile_classes_contexts_on_profile_context_id' }
      t.references :profile_class, index: { name: 'index_profile_classes_contexts_on_profile_class_id' }

      t.timestamps
    end
  end
end
