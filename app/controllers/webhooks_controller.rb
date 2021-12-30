class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

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
    when "checkout.session.completed"
      session = event.data.object
      session_with_expand = Stripe::Checkout::Session.retrieve({ id: session.id, expand: ["line_items", "metadata"]})
      session_with_expand.line_items.data.each do |line_item|
        tour = Tour.find_by(stripe_product_id: line_item.price.product)
        BookingSuccess.call(tour, session_with_expand.metadata)
      end
    end

    render json: { ok: true }
  end
end
