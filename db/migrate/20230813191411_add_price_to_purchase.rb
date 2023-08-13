class AddPriceToPurchase < ActiveRecord::Migration[7.0]
  def change
    add_column :purchases, :price, :decimal
  end
end
