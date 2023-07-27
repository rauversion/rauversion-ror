class CreateEventHosts < ActiveRecord::Migration[7.0]
  def change
    create_table :event_hosts do |t|
      t.string :name
      t.text :description
      t.references :event, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :listed_on_page
      t.boolean :event_manager

      t.timestamps
    end
  end
end
