class CheckoutController < ApplicationController
  before_action :current_user, only: [:create]
  before_action :load_tour, only: [:create]

  def create
    num = checkout_params[:adults] + checkout_params[:children] / 2
    if @tour.fixed? && ValidCheckout.call(@tour, num) == false
      render json: { messages: ['An unexpected error has occurred!'] }, status: 400
    end

    intent = Stripe::PaymentIntent.create({
      amount: checkout_params[:total].ceil(),
      currency: 'usd',
      metadata: checkout_params.merge(status: "paid").to_hash,
      automatic_payment_methods: {
        enabled: true,
      },
    })

    render json: {client_secret: intent.client_secret}, status: 200
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
    params.require(:checkout).permit(:tour_id, :children, :adults, :departure_date, :total, :user_id)
  end
end
