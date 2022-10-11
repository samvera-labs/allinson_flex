class AddLockingToProfile < ActiveRecord::Migration[5.1]
  def change
    add_column :allinson_flex_profiles, :locked_at, :datetime unless column_exists?(:allinson_flex_profiles, :locked_at)
    add_column :allinson_flex_profiles, :locked_by_id, :integer unless column_exists?(:allinson_flex_profiles, :locked_by_id)
  end
end
