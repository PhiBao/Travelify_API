class BookingBlueprint < Blueprinter::Base
  identifier :id
  fields :total, :adults, :children, :total, :created_at, 
         :departure_date, :status
  field :review_data, name: :review
  field :tour_name do |booking|
    booking.tour.name
  end
  field :tour_id do |booking|
    booking.tour.id
  end
  field :tour_image do |booking|
    booking.tour.images_data[0]
  end
end
