class EventTicket < ApplicationRecord
  belongs_to :event

  store_accessor :settings, :show_sell_until, :boolean
  store_accessor :settings, :show_after_sold_out, :boolean
  store_accessor :settings, :fee_type, :string
  store_accessor :settings, :hidden, :boolean
  store_accessor :settings, :max_tickets_per_order, :integer
  store_accessor :settings, :min_tickets_per_order, :integer
  store_accessor :settings, :sales_channel, :string
  store_accessor :settings, :after_purchase_message, :string



end
