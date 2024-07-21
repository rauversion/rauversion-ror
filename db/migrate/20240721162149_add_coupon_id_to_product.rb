class AddCouponIdToProduct < ActiveRecord::Migration[7.1]
  def change
    add_reference :products, :coupon, null: true, foreign_key: true
  end
end
