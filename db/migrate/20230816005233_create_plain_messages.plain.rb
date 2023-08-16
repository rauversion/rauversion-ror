# This migration comes from plain (originally 20230729010745)
class CreatePlainMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :plain_messages do |t|
      t.string :role
      t.text :content
      t.references :plain_conversation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
