class CreateCoupons < ActiveRecord::Migration[7.1]
  def change
    create_table :coupons do |t|
      t.references :user, null: false, foreign_key: true
      t.string :code, null: false
      t.string :discount_type, null: false
      t.decimal :discount_amount, null: false, precision: 10, scale: 2
      t.datetime :expires_at, null: false
      t.string :stripe_id

      t.timestamps
    end
    add_index :coupons, :code, unique: true
  end
end
