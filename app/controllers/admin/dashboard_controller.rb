module Admin
  class DashboardController < AdminController
    def index
      data = StatisticsData.call()
      render json: { data: data }, status: 200
    end

    def analytics
      data = AnalyticsData.call()
      render json: { data: data }, status: 200
    end
  end
end
