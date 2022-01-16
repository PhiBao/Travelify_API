module BookingsHelper
  def load_booking
    @booking = Booking.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { messages: ['Booking not found'] }, status: 404  
  end
end
