class TourBlueprint < Blueprinter::Base
  identifier :id
  fields :name, :kind, :description, :departure,
         :details, :price, :rate, :created_at
  field :images_data, name: :images
  field :vehicles_data, name: :vehicles
  field(:marked, if: ->(_field_name, _tour, options) { options[:user].present? }) do |tour, options|
    tour.actions.mark.find_by(user_id: options[:user].id).present?
  end
  association :tags, blueprint: TagBlueprint

  view :detail do
    association :reviews, blueprint: ReviewBlueprint do |tour, options|
      if options[:user]&.admin?
        tour.reviews.newest.page(1)
      else
        tour.reviews.appear.newest.page(1)
      end
    end
    field :size do |tour, options|
      if options[:user]&.admin?
        tour.reviews.size
      else
        tour.reviews.appear.size
      end
    end
  end
end
