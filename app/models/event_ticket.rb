class EventTicket < ApplicationRecord
  belongs_to :event

  has_many :purchased_items, as: :purchased_item

  has_many :purchased_tickets, -> { where(purchased_item_type: 'EventTicket') }, class_name: 'PurchasedItem', as: :purchased_tickets
  has_many :paid_tickets, -> { where(purchased_item_type: 'EventTicket', paid: true) }, class_name: 'PurchasedItem', as: :paid_tickets
  
  # has_many :pending_comments, -> { where(state: 'pending') }, class_name: 'Comment', as: :commentable

  store_accessor :settings, :show_sell_until, :boolean
  store_accessor :settings, :show_after_sold_out, :boolean
  store_accessor :settings, :fee_type, :string
  store_accessor :settings, :hidden, :boolean
  store_accessor :settings, :max_tickets_per_order, :integer
  store_accessor :settings, :min_tickets_per_order, :integer
  store_accessor :settings, :sales_channel, :string
  store_accessor :settings, :after_purchase_message, :string

  validates :title, presence: true
  validates :price, presence: true
  validates :qty, presence: true
  validates :selling_start, presence: true
  validates :selling_end, presence: true
  validates :short_description, presence: true

  validates :title, :price, :qty, :selling_start, :selling_end, :short_description, presence: true
  validate :selling_start_before_selling_end


  def free?
    price.to_i == 0
  end
  
  private

  def selling_start_before_selling_end
    return if selling_start.blank? || selling_end.blank?

    if selling_start >= selling_end
      errors.add(:selling_start, "must be before selling end")
    end
  end
  # scope :purchased_tickets, -> { where(:attibute => value)}
  # Ex:- scope :active, -> {where(:active => true)}

end
