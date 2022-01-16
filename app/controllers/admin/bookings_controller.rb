module Admin
  class BookingsController < ApplicationController
    include BookingsHelper
    before_action :load_booking, only: :destroy

    def index
      render json: { data: { list: BookingBlueprint.render_as_hash(Booking.all, view: :admin),
                             type: "bookings" } }, status: 200
    end

    def destroy
      if @booking.destroy
        render json: { id: @booking.id }
      else
        render json: { messages: @booking.errors.full_messages }, status: 400
      end
    end
  end
end
