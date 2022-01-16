class BookingsController < ApplicationController
  include BookingsHelper
  before_action :load_booking, only: :review

  def create
    @booking = Booking.create(booking_params)
    unless @booking.save
      render json: {messages: ["A error has occurred"]}, status: 400
    end
  end

  def review
    review = Review.create!(review_params.merge(booking_id: @booking.id))
    render json: { body: review.body, hearts: review.hearts, id: @booking.id }, status: 201
  end

  private

  def booking_params
    params.require(:booking).permit(:tour_id, :total, :adults, :children, :departure_date, :user_id,
                  :status, traveller_attributes: [:name, :email, :phone_number, :note])
  end

  def review_params
    params.permit(:body, :hearts)
  end
end
