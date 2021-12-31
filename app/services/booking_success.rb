class BookingSuccess < ApplicationService
  attr_reader :metadata

  def initialize(metadata)
    @metadata = metadata
  end

  def call
    tour = Tour.find(@metadata.tour_id)
    num = (@metadata.adults.to_i * 100.0 + @metadata.children.to_i * 100.0 / 2) / 100.0
    tour.update!(quantity: tour.quantity + num)
    booking = Booking.create!(@metadata.to_hash)
    booking.send_confirmed_mailer
  end
end
