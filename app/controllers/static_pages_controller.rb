class StaticPagesController < ApplicationController
  
  def home
    render json: { 
      data:
        { 
          featured: TourBlueprint.render_as_hash(Tour.first, view: :normal),
          hot_tours: TourBlueprint.render_as_hash(Tour.take(9), view: :normal),
          new_tours: TourBlueprint.render_as_hash(Tour.last(9), view: :normal),
          hot_tags: TagBlueprint.render_as_hash(Tag.popularity.first(6), view: :home)
        }
      }
  end
end