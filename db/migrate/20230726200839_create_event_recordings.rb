class CreateEventRecordings < ActiveRecord::Migration[7.0]
  def change
    create_table :event_recordings do |t|
      t.string :type
      t.string :title
      t.text :description
      t.text :iframe
      t.jsonb :properties
      t.integer :position
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
