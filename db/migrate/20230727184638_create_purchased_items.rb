class CreatePurchasedItems < ActiveRecord::Migration[7.0]
  def change
    create_table :purchased_items do |t|
      t.references :purchase, null: false, foreign_key: true
      t.references :purchased_item, polymorphic: true, null: false

      t.timestamps
    end
  end
end
