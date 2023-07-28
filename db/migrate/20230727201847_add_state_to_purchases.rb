class AddStateToPurchases < ActiveRecord::Migration[7.0]
  def change
    add_column :purchases, :state, :string
    add_index :purchases, :state
  end
end
