class AddStateToPurchasedItems < ActiveRecord::Migration[7.0]
  def change
    add_column :purchased_items, :state, :string
    add_index :purchased_items, :state
  end
end
