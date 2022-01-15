class ToursController < ApplicationController
  include ToursHelper
  before_action :load_tour, only: %i[show destroy mark reviews]
  before_action :logged_in_user, only: :mark

  def index
    page = params[:page] || 1
    case params[:type]
    when "hot"
      list = Tour.valid.hot
    when "favorite"
      list = Tour.valid.favorite
    when "search"
      list = Tour.search(search_params)
    when "mark"
      if current_user.present?
        ids = current_user.actions.mark.pluck(:target_id)
        list = Tour.where(id: ids)
      else
        list = Tour.valid.newest
      end
    when "tags"
      list = Tour.joins(:tour_tags).where(tour_tags: { tag_id: params[:uid] })
    else
      list = Tour.valid.newest
    end

    render json: TourBlueprint.render(list.page(page), root: :list, view: :normal,
                                      user: current_user, meta: { total: list.length })
  end

  def show
    if params[:watched]
      recently = params[:watched].split("-").compact_blank
                                 .map{ |id| Tour.find(id)}
                                 .reject { |x| x.id == @tour.id }
                                 .last(3)
    else
      recently = []
    end
    related = @tour.tags.map{ |tag| Tour.valid.includes(:tags)
                   .where("tags.name": tag.name ).to_a }
                   .flatten.uniq(&:id)
                   .reject { |x| x.id == @tour.id }.sample(3)
    list = ([].concat(recently, related)).uniq(&:id)

    render json: {
      list: TourBlueprint.render_as_hash(list, view: :normal, user: current_user),
      self: TourBlueprint.render_as_hash(@tour, view: :detail, user: current_user),
      related: related.pluck(:id),
      recently: recently ? recently.pluck(:id) : []
    }, status: 200
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

  def reviews
    page = params[:page] || 1
    if current_user&.admin?
      list = @tour.reviews.newest.page(page)
    else
      list = @tour.reviews.appear.newest.page(page)
    end

    render json: ReviewBlueprint.render(list, root: :reviews, user: current_user), status: 200
  end

  private

  def search_params
    params.permit(:date, :departure)
  end
end
