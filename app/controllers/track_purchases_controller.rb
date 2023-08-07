class TrackPurchasesController < ApplicationController

  def new
    @track = Track.friendly.find(params[:track_id])
    @payment = Payment.new
    @payment.assign_attributes(initial_price: @track.price)
    @purchase = current_user.purchases.new
  end

  def create
    @track = Track.friendly.find(params[:track_id])
    @payment = Payment.new
    @payment.assign_attributes(build_params)

    # When a customer purchases a ticket for an event:
    customer = current_user

    @purchase = current_user.purchases.new(purchasable: @track)

    @purchase.virtual_purchased = [ 
      VirtualPurchasedItem.new({resource: @track, quantity: 1})
    ]
  
    handle_stripe_session
  end


  def handle_stripe_session
    # @purchase.errors.add(:base, "hahahaha")
    account = @track.user.oauth_credentials.find_by(provider: "stripe_connect")
    Stripe.stripe_account = account.uid unless account.blank?

    ActiveRecord::Base.transaction do
      @purchase.store_items
      @purchase.save

      line_items = @purchase.purchased_items.group(:purchased_item_id).count.map do |k,v|
        {
          "quantity" => 1,
          "price_data" => {
            "unit_amount" => ((@track.price * v) * 100).to_i,
            "currency" => "USD",
            "product_data" => {
              "name" => @track.title,
              "description" => "#{@track.title} from #{@track.user.username}"
            }
          }
        }
      end 

      puts line_items

      fee_amount = 3

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
        success_url: success_track_track_purchase_url(@track, @purchase), # Replace with your success URL
        cancel_url:  failure_track_track_purchase_url(@track, @purchase)   # Replace with your cancel URL
      )

      @purchase.update(
        checkout_type: "stripe",
        checkout_id: @session["id"]
      )

      @payment_url = @session["url"]
    end
  end

  def build_params
    params.require(:payment).permit(:include_message, :optional_message)
  end
end
