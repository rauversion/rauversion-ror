class CreateEventSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :event_schedules do |t|
      t.references :event, null: false, foreign_key: true
      t.datetime :start_date
      t.datetime :end_date
      t.string :schedule_type
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
