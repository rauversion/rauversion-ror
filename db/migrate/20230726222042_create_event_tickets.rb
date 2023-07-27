class CreateEventTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :event_tickets do |t|
      t.string :title
      t.decimal :price
      t.decimal :early_bird_price
      t.decimal :standard_price
      t.integer :qty
      t.datetime :selling_start
      t.datetime :selling_end
      t.string :short_description
      t.jsonb :settings
      t.references :event, null: false, foreign_key: true
      t.timestamps
    end
  end
end
