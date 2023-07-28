class AddPurchasableToPurchases < ActiveRecord::Migration[7.0]
  def change
    add_column :purchases, :purchasable_type, :string
    add_column :purchases, :purchasable_id, :bigint
    add_index :purchases, [:purchasable_type, :purchasable_id]
  end
end
