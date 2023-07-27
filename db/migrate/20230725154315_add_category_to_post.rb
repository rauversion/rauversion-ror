class AddCategoryToPost < ActiveRecord::Migration[7.0]
  def change
    add_reference :posts, :category, null: true, foreign_key: true
  end
end
