class AddSellerToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :seller, :boolean
    add_index :users, :seller
  end
end
