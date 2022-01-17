module Admin
  class BookingsController < ApplicationController
    include BookingsHelper
    before_action :load_booking, only: %i[update destroy] 

    def index
      render json: { data: { list: BookingBlueprint.render_as_hash(Booking.all.order(id: :desc), view: :admin),
                             type: "bookings" } }, status: 200
    end

    def create
      @booking = Booking.create(booking_params)
      if @booking.save
        @booking.send_confirmed_mailer if @booking.paid?
        render json: BookingBlueprint.render(@booking, view: :admin, root: :booking), status: 200
      else
        render json: { messages: ["A error has occurred"] }, status: 400
      end
    end

    def update
      send_mail = true if (update_params[:status] == "paid" && update_params[:status] != @booking.status)
      
      if @booking.update(update_params)
        if send_mail 
          @booking.send_confirmed_mailer
        end
        render json: BookingBlueprint.render(@booking, view: :admin, root: :booking), status: 200
      else
        render json: { messages: @booking.errors.full_messages }, status: 400
      end
    end

    def destroy
      if @booking.destroy
        render json: { id: @booking.id }
      else
        render json: { messages: @booking.errors.full_messages }, status: 400
      end
    end

    def helpers
      data = Tour.valid.map do |item|
        {
          value: item.id,
          label: item.name,
          price: item.price,
          kind: item.kind,
          departureDate: item.fixed? ? item.begin_date : "",
        }
      end

      render json: {data: data}, status: 200
    end

    private

    def update_params
      params.require(:booking).permit(:adults, :children, :departure_date, :total, :status)
    end
  end
end
