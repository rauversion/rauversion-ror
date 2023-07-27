class Event < ApplicationRecord
  belongs_to :user

  has_many :event_hosts
  has_many :event_schedules
  has_many :event_recordings
  has_many :schedule_schedulings, through: :event_schedules
  has_many :event_tickets

  extend FriendlyId
  friendly_id :title, use: :slugged

  accepts_nested_attributes_for :event_hosts, allow_destroy: true
  accepts_nested_attributes_for :event_schedules, allow_destroy: true
  accepts_nested_attributes_for :event_tickets, allow_destroy: true
  accepts_nested_attributes_for :event_recordings, allow_destroy: true

  store_accessor :event_settings, :participant_label, :string, default: "speakers"
  store_accessor :event_settings, :participant_description, :string
  store_accessor :event_settings, :accept_sponsors, :boolean
  store_accessor :event_settings, :sponsors_label, :string
  store_accessor :event_settings, :sponsors_description, :string
  store_accessor :event_settings, :public_streaming, :boolean
  store_accessor :event_settings, :payment_gateway, :string
  store_accessor :event_settings, :scheduling_label, :string
  store_accessor :event_settings, :scheduling_description, :string
  store_accessor :event_settings, :ticket_currency, :string

  scope :published, -> { where(:state => "published")}
  scope :drafts, -> { where(:state => "draft")}

  include AASM
  aasm column: :state do
    state :draft, initial: true
    state :published

    event :run do
      transitions from: :draft, to: :published
    end
  end

  def self.format_date_range(start_date, end_date)
    # If end_date is nil or same as start_date, just show start_date
    if end_date.nil? || start_date.to_date == end_date.to_date
      I18n.l(start_date, format: :day_with_year)
    else
      # If end_date exists and is different from start_date, show range
      "#{I18n.l(start_date, format: :day)} to #{I18n.l(end_date, format: :day_with_year)}"
    end
  end
end
