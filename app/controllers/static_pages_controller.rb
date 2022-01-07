class StaticPagesController < ApplicationController
  
  def home
    featured = Tour.valid.favorite.first(3)
    hot_tours = Tour.valid.hot.first(9)
    new_tours = Tour.valid.last(9)
    list = ([].concat(hot_tours, new_tours, featured)).uniq(&:id)
    hot_tags = Tag.popularity.first(6)
    
    render json: { 
      data:
        { 
          list: TourBlueprint.render_as_hash(list, user: current_user),
          featured: featured.pluck(:id),
          hot_tours: hot_tours.pluck(:id),
          new_tours: new_tours.pluck(:id),
          hot_tags: TagBlueprint.render_as_hash(hot_tags, view: :home)
        }
      }
  end
end
