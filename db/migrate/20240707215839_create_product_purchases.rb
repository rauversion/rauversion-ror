class CreateProductPurchases < ActiveRecord::Migration[7.1]
  def change
    create_table :product_purchases do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :total_amount
      t.string :status
      t.string :stripe_session_id

      t.timestamps
    end
  end
end
