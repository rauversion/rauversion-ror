class WebhooksController < ApplicationController

  skip_before_action :verify_authenticity_token

  def create
    handle_webhook(provider: params[:provider])
  end

  def handle_webhook(provider:)
    case provider
    when "stripe" then handle_stripe
    else 
      render json: {status: :nok}, status: 422
    end
  end

  def handle_stripe
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil
    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, ENV['STRIPE_SIGNING_SECRET'])
    rescue JSON::ParserError => e
      # Invalid payload
      render json: { error: { message: e.message }}, status: :bad_request
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      render json: { error: { message: e.message, extra: "Sig verification failed" }}, status: :bad_request
      return
    end

    # Handle the event
    case event.type
    when 'payment_intent.succeeded'
      payment_intent = event.data.object # contains a Stripe::PaymentIntent
      puts 'PaymentIntent was successful!'
    when 'checkout.session.completed'
      confirm_stripe_purchase(event.data.object)
    when 'payment_method.attached'
      payment_method = event.data.object # contains a Stripe::PaymentMethod
      puts 'PaymentMethod was attached to a Customer!'
      # ... handle other event types
    else
      puts "Unhandled event type: #{event.type}"
    end

    render json: { message: :success }
  end

  def confirm_stripe_purchase(event_object)
    purchase = Purchase.find_by(checkout_type: "stripe", checkout_id: event_object.id)
    if purchase.present?
      purchase.complete_purchase!
    end
  end
end
