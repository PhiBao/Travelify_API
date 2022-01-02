class StaticPagesController < ApplicationController
  
  def home
    featured = Tour.valid.first(3)
    hot_tours = Tour.valid.take(9)
    new_tours = Tour.valid.last(9)
    list = ([].concat(hot_tours, new_tours, featured)).uniq(&:id)
    hot_tags = Tag.popularity.first(6)
    
    render json: { 
      data:
        { 
          list: TourBlueprint.render_as_hash(list, view: :normal, user_id: current_user&.id),
          featured: featured.pluck(:id),
          hot_tours: hot_tours.pluck(:id),
          new_tours: new_tours.pluck(:id),
          hot_tags: TagBlueprint.render_as_hash(hot_tags, view: :home)
        }
      }
  end
end
