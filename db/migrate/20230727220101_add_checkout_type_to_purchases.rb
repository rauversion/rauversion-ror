class AddCheckoutTypeToPurchases < ActiveRecord::Migration[7.0]
  def change
    add_column :purchases, :checkout_type, :string
    add_index :purchases, :checkout_type
    add_column :purchases, :checkout_id, :string
  end
end
