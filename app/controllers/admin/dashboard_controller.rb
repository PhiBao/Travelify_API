module Admin
  class DashboardController < AdminController
    def index
      featured = StatisticsData.call()
      render json: { 
        data: { 
          featured: featured
        }
      }, status: 200
    end
  end
end
