class BookingsController < ApplicationController
  include BookingsHelper
  before_action :load_booking, only: :review

  def create
    @booking = Booking.create(booking_params)
    if @booking.save
      if @booking.status == "confirming"
        Notification.booked.create!(user_id: 1,
                                    recipient_id: 1,
                                    notifiable: @booking.tour)
      end
    else
      render json: { messages: ["A error has occurred"] }, status: 400
    end
  end

  def review
    review = Review.create!(review_params.merge(booking_id: @booking.id))
    render json: { body: review.body, hearts: review.hearts, id: @booking.id }, status: 201
  end

  private

  def review_params
    params.permit(:body, :hearts)
  end
end
