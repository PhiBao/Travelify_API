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

    def revenues
      data = RevenuesData.call()
      render json: { data: data }, status: 200
    end

    def search
      data = Booking.paid.statistic_at(Date.parse("#{params[:month]}/#{params[:year]}"))
                    .group_by_day(:updated_at).sum(:total).map { |k, v| { name: k, value: v } }
      render json: { data: data }, status: 200
    end
  end
end
