class CreateProductShippings < ActiveRecord::Migration[7.1]
  def change
    create_table :product_shippings do |t|
      t.references :product, null: false, foreign_key: true
      t.string :country
      t.decimal :base_cost, precision: 10, scale: 2
      t.decimal :additional_cost, precision: 10, scale: 2
      t.boolean :is_default, default: false
      t.timestamps
    end
  end
end
