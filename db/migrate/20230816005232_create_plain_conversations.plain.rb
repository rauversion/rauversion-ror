# This migration comes from plain (originally 20230729010703)
class CreatePlainConversations < ActiveRecord::Migration[7.0]
  def change
    create_table :plain_conversations do |t|
      t.string :subject
      t.datetime :pinned_at
      t.boolean :pinned

      t.timestamps
    end
  end
end
