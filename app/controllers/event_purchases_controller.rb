class EventPurchasesController < ApplicationController
  def new
    @event = Event.friendly.find(params[:event_id])
    
    # When a customer purchases a ticket for an event:
    customer = current_user
    #ticket = EventTicket.find_by(id: ticket_id)

    @tickets = @event.available_tickets(Time.zone.now)

    @purchase = current_user.purchases.new
    @purchase.virtual_purchased = @tickets.map do |aa|
      VirtualPurchasedItem.new({resource: aa, quantity: 1})
    end
    #if Purchase.is_ticket_valid?(ticket, current_user, desired_quantity)
    #  purchase = Purchase.create(customer: customer, purchased_item: ticket)
      # Add any additional logic related to the purchase (e.g., updating ticket quantity, calculating total_amount, etc.).
    #else
      # Handle the case where the ticket is not valid for purchase.
    #end
  end


  def create
    @event = Event.friendly.find(params[:event_id])
    
    # When a customer purchases a ticket for an event:
    customer = current_user
    #ticket = EventTicket.find_by(id: ticket_id)

    @tickets = @event.available_tickets(Time.zone.now)
    @purchase = current_user.purchases.new(purchasable: @event)
    @purchase.virtual_purchased = @tickets.map do |aa|
      VirtualPurchasedItem.new({resource: aa, quantity: 1})
    end

    # @purchase.errors.add(:base, "hahahaha")

    account = @event.user.oauth_credentials.find_by(provider: "stripe_connect")
    Stripe.stripe_account = account.uid

    ActiveRecord::Base.transaction do
      @purchase.store_items
      @purchase.save

      line_items = @purchase.purchased_items.group(:purchased_item_id).count.map do |k,v|
        ticket = EventTicket.find(k)
        {
          "quantity" => v,
          "price_data" => {
            "unit_amount" => ((ticket.price * v) * 100).to_i,
            "currency" => ticket.event.ticket_currency,
            "product_data" => {
              "name" => ticket.title,
              "description" => "#{ticket.short_description} \r for event: #{ticket.event.title}"
            }
          }
        }
      end 

      puts line_items
      fee_amount = 100

      @session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        line_items: line_items,
        payment_intent_data: {
          application_fee_amount: fee_amount
          # "transfer_data"=> %{
          #  "destination"=> c.uid
          # }
        },
        customer_email: current_user.email,
        mode: "payment",
        success_url: success_event_event_purchase_url(@event, @purchase), # Replace with your success URL
        cancel_url:  failure_event_event_purchase_url(@event, @purchase)   # Replace with your cancel URL
      )

      @purchase.update(
        checkout_type: "stripe",
        checkout_id: @session["id"]
      )
    end
        #if Purchase.is_ticket_valid?(ticket, current_user, desired_quantity)
    #  purchase = Purchase.create(customer: customer, purchased_item: ticket)
      # Add any additional logic related to the purchase (e.g., updating ticket quantity, calculating total_amount, etc.).
    #else
      # Handle the case where the ticket is not valid for purchase.
    #end
  end

  def success
    @event = Event.friendly.find(params[:event_id])
    @purchase = current_user.purchases.find(params[:id])
    render "show"
  end

  def failure
    @event = Event.friendly.find(params[:event_id])
    @purchase = current_user.purchases.find(params[:id])
    render "show"
  end
end
