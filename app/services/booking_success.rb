class BookingSuccess < ApplicationService
  attr_reader :tour, :metadata

  def initialize(tour, booking)
    @tour = tour
    @metadata = metadata
  end

  def call
    tour = Tour.find(@booking.tour_id)
    num = @metadata.adults + @metadata.children / 2
    tour.update!(quantity: @tour.quantity + num)
    booking = Booking.create!(user_id: current_user.id,
                    tour_id: @tour.id,
                    adults: @metadata.adults,
                    children: @metadata.children,
                    departure_date: @metadata.departure_date,
                    status: "paid",
                    total: num * @tour.price)
    booking.send_confirmed_mailer
  end
end