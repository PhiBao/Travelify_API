class WebhooksController < ApplicationController

  def create
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, ENV["WEBHOOKS"]
      )
    rescue JSON::ParserError
      status 400
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      puts "Signature error"
      p e
      return
    end

    # Handle the event
    case event.type
    when "payment_intent.succeeded"
      intent = Stripe::PaymentIntent.retrieve({ id: event.data.object.id })
      BookingSuccess.call(intent.metadata)
    end

    render json: { ok: true }
  end
end
