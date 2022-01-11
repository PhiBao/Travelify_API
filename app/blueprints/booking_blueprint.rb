class BookingBlueprint < Blueprinter::Base
  identifier :id
  fields :total, :created_at, :status

  view :history do
    fields :adults, :children, :departure_date
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

  view :transaction do
    field :short_customer, name: :customer
  end
end
