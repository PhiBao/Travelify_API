class VehiclesController < ApplicationController

  def index
    render json: VehicleBlueprint.render(Vehicle.all), status: 200
  end
end