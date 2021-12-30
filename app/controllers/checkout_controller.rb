class CheckoutController < ApplicationController
  before_action :current_user, only: [:create]
  before_action :load_tour, only: [:create]

  def create
    num = checkout_params[:adults] + checkout_params[:children] / 2
    
    if @tour.fixed? && ValidCheckout.call(@tour, num) == false
      render json: { messages: ['An unexpected error has occurred!'] }, status: 400
    end
    line_items = [{
      price: @tour.stripe_price_id,
      quantity: num,
    }]
    @session = Stripe::Checkout::Session.create({
      customer: current_user.stripe_customer_id,
      payment_method_types: ['card'],
      line_items: line_items,
      metadata: {
        adults: checkout_params[:adults],
        children: checkout_params[:children],
        departure_date: checkout_params[:departure_date]
      },
      allow_promotion_codes: true,
      mode: "payment",
      success_url: success_url,
      cancel_url: cancel_url,
    })

    redirect_to @session.url, allow_other_host: true, status: 301
  end

  def success
    render json: { ok: true }, status: 200
  end

  def cancel
    render json: { messages: ['An unexpected error has occurred!'] }, status: 403
  end

  private

  def load_tour
    @tour = Tour.find(checkout_params[:tour_id])
  rescue ActiveRecord::RecordNotFound
    render json: { messages: ['Tour not found'] }, status: 404  
  end

  def checkout_params
    params.require(:checkout).permit(:tour_id, :children, :adults, :departure_date)
  end
end