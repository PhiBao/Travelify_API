module BookingsHelper
  def load_booking
    @booking = Booking.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { messages: ['Booking not found'] }, status: 404  
  end

  def booking_params
    params.require(:booking).permit(:tour_id, :total, :adults, :children, :departure_date, :user_id,
                  :status, traveller_attributes: [:name, :email, :phone_number, :note])
  end
end
