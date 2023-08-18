class ScheduleScheduling < ApplicationRecord
  belongs_to :event_schedule

  validates :title, :start_date, :end_date, :short_description, presence: true

  validates :start_date, comparison: { greater_than: :end_date }

end
