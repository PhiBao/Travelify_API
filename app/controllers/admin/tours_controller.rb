module Admin
  class ToursController < AdminController
    include ToursHelper
    before_action :load_tour, only: %i[update destroy]

    def index
      render json: { tours: { list: TourBlueprint.render_as_hash(Tour.all, view: :admin),
                              type: "tours",
                              vehicles: VehicleBlueprint.render_as_hash(Vehicle.all),
                              tags: TagBlueprint.render_as_hash(Tag.all, view: :option) } }, status: 200
    end

    def create
      tour = Tour.new(tour_params)

      if tour.save
        render json: TourBlueprint.render(tour, view: :admin, root: :tour), status: 201
      else
        render json: { messages: tour.errors.full_messages }, status: 400
      end
    end

    def update
      if @tour.update(tour_params)
        render json: TourBlueprint.render(@tour, view: :admin, root: :tour), status: 200
      else
        render json: { messages: @tour.errors.full_messages }, status: 400
      end
    end

    def destroy
      if @tour.destroy
        render json: { id: @tour.id }
      else
        render json: { messages: @tour.errors.full_messages }, status: 400
      end
    end

    private

    def tour_params
      params.permit(:name, :description, :time, :begin_date, :departure,
                    :return_date, :price, :kind, :limit, :vehicles, :tags, images: [])
            .tap do |attrs| 
              attrs['tour_vehicles_attributes'] = JSON.parse(attrs.delete('vehicles')) 
              attrs['tour_tags_attributes'] = JSON.parse(attrs.delete('tags')) 
            end
    end
  end
end
