class AddProductToRelease < ActiveRecord::Migration[7.2]
  def change
    add_reference :releases, :product, null: true, foreign_key: true
  end
end
