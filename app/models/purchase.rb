class Purchase < ApplicationRecord
  belongs_to :user
  has_many :purchased_items
  belongs_to :purchasable, polymorphic: true

  attr_writer :virtual_purchased

  def virtual_purchased
    @virtual_purchased || []
  end

  def virtual_purchased_attributes=(attributes)
    array = attributes.keys.map { |o| attributes[o] }
    @virtual_purchased = array.map { |o| o }
    # array.map{|o| ScheduleRecord.new(o) }
  end

  def validate_purchased_items
    return if @virtual_purchased.blank?

    @virtual_purchased.each do |purchased_item|
      ticket = purchased.ticket

      # Check if the ticket with the specified ID exists
      if ticket.nil?
        errors.add(:base, "Ticket with ID #{purchased_item.ticket_id} does not exist.")
        next
      end

      # Check if the ticket quantity is sufficient for purchase
      if ticket.qty < purchased_item.quantity
        errors.add(:base, "Insufficient quantity for Ticket ID #{ticket.id}. Available: #{ticket.qty}. Requested: #{purchased_item.quantity}.")
        next
      end

      # Check if the total quantity purchased for this ticket in all previous purchases
      # does not exceed the ticket's available quantity
      total_purchased_quantity = PurchasedItem.where(ticket_id: purchased_item.ticket_id).sum(:quantity)
      if ticket.qty < total_purchased_quantity + purchased_item.quantity
        errors.add(:base, "Exceeded available quantity for Ticket ID #{ticket.id}. Already Purchased: #{total_purchased_quantity}. Requested: #{purchased_item.quantity}.")
      end

      # Check if the purchased quantity meets the :min_tickets_per_order setting
      if ticket.settings.present? && ticket.settings['min_tickets_per_order'].to_i > purchased_item.quantity
        errors.add(:base, "Ticket ID #{ticket.id} requires a minimum of #{ticket.settings['min_tickets_per_order']} tickets per order.")
      end

      # Check if the purchased quantity exceeds the :max_tickets_per_order setting
      if ticket.settings.present? && ticket.settings['max_tickets_per_order'].present? && ticket.settings['max_tickets_per_order'].to_i < purchased_item.quantity
        errors.add(:base, "Ticket ID #{ticket.id} allows a maximum of #{ticket.settings['max_tickets_per_order']} tickets per order.")
      end
    end
  end

  def store_items
    self.virtual_purchased.each do |a|
      a.quantity.times.each do 
        self.purchased_items << PurchasedItem.new(purchased_item: a.resource )
      end
    end
  end

  def complete_purchase!
    self.update(state: "paid")
    self.purchased_items.update_all(state: "paid")
  end

  def notify_purchase
    PurchasesMailer.event_ticket_confirmation(purchase: self)
  end

  def is_downloadable?
    state == "paid" or state == "free_access"
  end
end
