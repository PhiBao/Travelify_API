module ToursHelper
  def load_tour
    @tour = Tour.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { messages: ['Tour not found'] }, status: 404  
  end
end
