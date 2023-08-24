class Event < ApplicationRecord
  belongs_to :user

  has_many :event_hosts
  has_many :event_schedules
  has_many :event_recordings
  has_many :schedule_schedulings, through: :event_schedules
  has_many :event_tickets
  has_many :purchases, as: :purchasable
  has_many :purchased_items, through: :purchases
  has_many :paid_purchased_items, through: :purchases, class_name: "PurchasedItem", source: :purchased_items
  has_many :purchased_event_tickets, -> {
    where(purchased_items: {purchased_item_type: "EventTicket"})
  }, through: :purchased_items, source: :purchased_item, source_type: "EventTicket"

  # has_many :paid_tickets,

  has_one_attached :cover

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

  scope :published, -> { where(state: "published") }
  scope :drafts, -> { where(state: "draft") }
  scope :managers, -> { where(event_manager: true) }
  # Ex:- scope :active, -> {where(:active => true)}

  scope :public_events, -> {
    # where(private: false)
    where(state: "published")
  }

  scope :upcoming_events, -> {
    public_events.where("event_start >= ?", Time.now)
      .order(event_start: :asc)
  }

  scope :past_events, -> {
    public_events.where("event_start <= ?", Time.now)
      .order(event_start: :desc)
  }

  include AASM
  aasm column: :state do
    state :draft, initial: true
    state :published

    event :run do
      transitions from: :draft, to: :published
    end
  end

  def available_tickets(argument)
    event_tickets
      .where("selling_start <= ?", argument)
      .where("selling_end >= ?", argument)
      .where("qty > ?", 0)
  end

  def self.format_date_range(start_date, end_date)
    return if end_date.nil?
    # If end_date is nil or same as start_date, just show start_date
    if end_date.nil? || start_date.to_date == end_date.to_date
      I18n.l(start_date, format: :day_with_year)
    else
      # If end_date exists and is different from start_date, show range
      "#{I18n.l(start_date, format: :day)} to #{I18n.l(end_date, format: :day_with_year)}"
    end
  end

  def presicion_for_currency
    0
  end

  def toggle_published!
    new_state = (state == "published") ? "draft" : "published"
    update(state: new_state)
  end

  def event_dates
    self.class.format_date_range(event_start, event_ends)
  end

  def cover_url(size = nil)
    url = case size
    when :medium
      cover.variant(resize_to_limit: [200, 200]) # &.processed&.url

    when :large
      cover.variant(resize_to_limit: [500, 500]) # &.processed&.url

    when :small
      cover.variant(resize_to_limit: [50, 50]) # &.processed&.url

    else
      cover.variant(resize_to_limit: [200, 200]) # &.processed&.url
    end

    url || "daniel-schludi-mbGxz7pt0jM-unsplash-sqr-s-bn.png"
  end

  def sales_count
    purchased_event_tickets
      .where("purchased_items.state =?", "paid").sum("price")
  end

  def tickets_sold
    paid_purchased_items.size
  end
end
