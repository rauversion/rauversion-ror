class EventSchedule < ApplicationRecord
  belongs_to :event
  has_many :schedule_schedulings

  accepts_nested_attributes_for :schedule_schedulings, allow_destroy: true

  validates :start_date, :end_date, presence: true
  validate :start_date_before_end_date

  private

  def start_date_before_end_date
    return if start_date.blank? || end_date.blank?

    if start_date >= end_date
      errors.add(:start_date, "must be before end date")
    end
  end
end
