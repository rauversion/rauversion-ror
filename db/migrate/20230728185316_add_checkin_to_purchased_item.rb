class AddCheckinToPurchasedItem < ActiveRecord::Migration[7.0]
  def change
    add_column :purchased_items, :checked_in, :boolean
    add_index :purchased_items, :checked_in
    add_column :purchased_items, :checked_in_at, :datetime
  end
end
