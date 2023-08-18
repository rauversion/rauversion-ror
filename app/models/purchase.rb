class Purchase < ApplicationRecord
  belongs_to :user
  has_many :purchased_items
  belongs_to :purchasable, polymorphic: true

  attr_writer :virtual_purchased

  validate :validate_purchased_items

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
      resource = purchased_item.resource

      case resource.class.to_s
      when "EventTicket"
        validate_ticket(resource, purchased_item) 
      # TODO: when "Track" # how to validate track? pricing       
      else
        
      end

    end
  end

  def validate_ticket(ticket, purchased_item)
    # Check if the ticket with the specified ID exists
    if ticket.blank?
      errors.add(:base, "Ticket with ID #{purchased_item.ticket_id} does not exist.")
    end

    # Check if the ticket quantity is sufficient for purchase
    if purchased_item.quantity <= ticket.qty
      errors.add(:base, "Insufficient quantity for Ticket ID #{ticket.id}. Available: #{ticket.qty}. Requested: #{purchased_item.quantity}.")
    end

    # Check if the total quantity purchased for this ticket in all previous purchases
    # does not exceed the ticket's available quantity
    total_purchased_quantity = self.purchasable.purchased_event_tickets.where(id: ticket.id).size
    if total_purchased_quantity + purchased_item.quantity > ticket.qty
      errors.add(:base, "Exceeded available quantity for Ticket ID #{ticket.id}. Already Purchased: #{total_purchased_quantity}. Requested: #{purchased_item.quantity}.")
    end

    # Check if the purchased quantity meets the :min_tickets_per_order setting
    if ticket.min_tickets_per_order.present? && purchased_item.quantity < ticket.min_tickets_per_order.to_i
      errors.add(:base, "Ticket ID #{ticket.id} requires a minimum of #{ticket.settings['min_tickets_per_order']} tickets per order.")
    end

    # Check if the purchased quantity exceeds the :max_tickets_per_order setting
    if ticket.max_tickets_per_order.present? && purchased_item.quantity > ticket.max_tickets_per_order.to_i
      errors.add(:base, "Ticket ID #{ticket.id} allows a maximum of #{ticket.settings['max_tickets_per_order']} tickets per order.")
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
