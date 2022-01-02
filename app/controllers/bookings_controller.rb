class BookingsController < ApplicationController
  def create
    @booking = Booking.create(booking_params)
    unless @booking.save
      render json: {messages: ["A error has occurred"]}, status: 400
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:tour_id, :total, :adults, :children, :departure_date, :user_id,
                  :status, traveller_attributes: [:name, :email, :phone_number, :note])
  end
end
