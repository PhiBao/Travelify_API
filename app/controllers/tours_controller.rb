class ToursController < ApplicationController
  before_action :admin_user, only: [:create, :update, :destroy]
  before_action :load_tour, only: [:update, :destroy]

  def index
    Tour.order(paginate_params[:order])
        .page(paginate_params[:page])
  end

  def create
    tour = Tour.new(tour_params)

    if tour.save
      render json: tour, status: 201
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
    if @tour.destroy
      render json: { ok: true }, status: 200
    else
      render json: { messages: @tour.errors.full_messages }, status: 400
    end
  end

  private

  def paginate_params
    params.permit(:page, order: [])
  end

  def tour_params
    params.permit(:name, :description, :time, :departure_day,
                  :terminal_day, :price, :kind, :limit, images: [])
  end

  def load_tour
    @tour = Tour.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { messages: ['Tour not found'] }, status: 404  
  end
end
