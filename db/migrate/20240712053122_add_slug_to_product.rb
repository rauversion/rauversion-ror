class AddSlugToProduct < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :slug, :string
    add_index :products, :slug
  end
end
