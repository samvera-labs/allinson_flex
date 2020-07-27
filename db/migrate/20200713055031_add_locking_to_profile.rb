class AddLockingToProfile < ActiveRecord::Migration[5.1]
  def change
    add_column :allinson_flex_profiles, :locked_at, :datetime
    add_column :allinson_flex_profiles, :locked_by_id, :integer
  end
end
