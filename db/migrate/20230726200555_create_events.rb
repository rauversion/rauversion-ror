class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.string :slug
      t.string :state
      t.string :timezone
      t.datetime :event_start
      t.datetime :event_ends
      t.boolean :private
      t.boolean :online
      t.string :location
      t.string :street
      t.string :street_number
      t.integer :lat
      t.integer :lng
      t.string :venue
      t.string :country
      t.string :city
      t.string :province
      t.string :postal
      t.string :age_requirement
      t.boolean :event_capacity
      t.integer :event_capacity_limit
      t.boolean :eticket
      t.boolean :will_call
      t.jsonb :order_form
      t.jsonb :widget_button
      t.string :event_short_link
      t.jsonb :tax_rates_settings
      t.jsonb :attendee_list_settings
      t.jsonb :scheduling_settings
      t.jsonb :event_settings
      t.jsonb :tickets
      t.references :user, null: false, foreign_key: true
      t.jsonb :streaming_service

      t.timestamps
    end
  end
end
