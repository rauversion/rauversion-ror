class AddProductOptionsAndNewFieldsToProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :product_options do |t|
      t.references :product, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :quantity
      t.string :sku, null: false

      t.timestamps
    end

    add_index :product_options, :sku, unique: true

    add_column :products, :limited_edition, :boolean, default: false
    add_column :products, :limited_edition_count, :integer
    add_column :products, :include_digital_album, :boolean, default: false
    add_column :products, :visibility, :string, default: 'private'
    add_column :products, :name_your_price, :boolean, default: false
    add_column :products, :shipping_days, :integer
    add_column :products, :shipping_begins_on, :date
    add_column :products, :shipping_within_country_price, :decimal, precision: 10, scale: 2
    add_column :products, :shipping_worldwide_price, :decimal, precision: 10, scale: 2
    add_column :products, :quantity, :integer
  end
end