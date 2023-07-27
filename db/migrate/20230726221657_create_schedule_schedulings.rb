class CreateScheduleSchedulings < ActiveRecord::Migration[7.0]
  def change
    create_table :schedule_schedulings do |t|
      t.references :event_schedule, null: false, foreign_key: true
      t.datetime :start_date
      t.datetime :end_date
      t.string :name
      t.string :short_description

      t.timestamps
    end
  end
end
