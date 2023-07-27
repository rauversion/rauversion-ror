class EventSchedule < ApplicationRecord
  belongs_to :event
  has_many :schedule_schedulings

  accepts_nested_attributes_for :schedule_schedulings, allow_destroy: true

end
