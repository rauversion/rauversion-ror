class AddEditorToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :editor, :boolean
  end
end
