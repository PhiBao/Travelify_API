class BookingMailer < ApplicationMailer
  def booking_confirmed(booking)
    @booking = booking
    
    mail(
      to: @booking.user.email,
      subject: "Booking Confirmed "
    )
  end
end
