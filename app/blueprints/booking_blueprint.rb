class BookingBlueprint < Blueprinter::Base
  identifier :id
  fields :created_at, :status
  field :total_formatter, name: :total

  view :history do
    fields :adults, :children, :departure_date
    field :review_data, name: :review
    field :tour_name do |booking|
      booking.tour&.name
    end
    field :tour_id do |booking|
      booking.tour&.id
    end
    field :tour_image do |booking|
      booking.tour&.images_data[0]
    end
  end

  view :transaction do
    field :short_customer, name: :customer
  end

  view :admin do
    fields :adults, :children, :departure_date, :status
    field :tour_data, name: :tour
    field :is_user do |booking|
      !!booking.user
    end
    field :full_customer, name: :customer
  end
end
