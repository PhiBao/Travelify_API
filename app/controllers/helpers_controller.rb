class HelpersController < ApplicationController

  def index
    render json: {
      vehicles: VehicleBlueprint.render_as_hash(Vehicle.all),
      tags: TagBlueprint.render_as_hash(Tag.all)
    }, status: 200
  end
end