class ToursController < ApplicationController
  # before_action :admin_user, only: [:create, :update, :destroy]
  before_action :load_tour, only: [:show, :update, :destroy, :mark]
  before_action :logged_in_user, only: [:mark]

  def index
    Tour.order(paginate_params[:order])
        .page(paginate_params[:page])
  end

  def show
    recently = params[:watched].split("-").compact_blank
                               .map{ |id| Tour.find(id)}
                               .reject { |x| x.id == @tour.id }
                               .last(3) if params[:watched]
    related = @tour.tags.map{ |tag| Tour.valid.includes(:tags)
                   .where("tags.name": tag.name ).to_a }
                   .flatten.uniq(&:id)
                   .reject { |x| x.id == @tour.id }.sample(3)
    list = ([].concat(recently, related).push(@tour)).uniq(&:id)

    render json: {
      list: TourBlueprint.render_as_hash(list, view: :normal, user_id: current_user&.id),
      self: @tour.id,
      related: related.pluck(:id),
      recently: recently ? recently.pluck(:id) : []
    }, status: 200
  end

  def create
    tour = Tour.new(tour_params)

    if tour.save
      render json: TourBlueprint.render(tour, root: :tour, view: :created), status: 201
    else
      render json: { messages: tour.errors.full_messages }, status: 400
    end
  end

  def update
    if @tour.update(tour_params)
      render json: @tour, status: 200
    else
      render json: { messages: @tour.errors.full_messages }, status: 400
    end
  end

  def destroy
    unless @tour.destroy
      render json: { messages: @tour.errors.full_messages }, status: 400
    end
  end

  def mark
    act = @tour.actions.mark.find_by(user_id: current_user.id)
 
    if act.present?
      act.destroy!
    else
      @tour.actions.mark.create!(user_id: current_user.id)
    end

    render json: { id: @tour.id }, status: 200
  end

  private

  def paginate_params
    params.permit(:page, order: [])
  end

  def tour_params
    params.permit(:name, :description, :time, :begin_date, :departure,
                  :return_date, :price, :kind, :limit, :vehicles, :tags, images: [])
          .tap do |attrs| 
            attrs['tour_vehicles_attributes'] = JSON.parse(attrs.delete('vehicles')) 
            attrs['tour_tags_attributes'] = JSON.parse(attrs.delete('tags')) 
          end
  end

  def action_params
    params.require(:rating).permit(:data)
  end

  def load_tour
    @tour = Tour.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { messages: ['Tour not found'] }, status: 404  
  end
end
