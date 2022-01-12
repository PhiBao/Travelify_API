class AnalyticsData < ApplicationService
  attr_reader :data

  def initialize(data = {})
    @data = data
  end

  def call
    now = Date.today
    trend_topics = Booking.statistic_at(now).joins(tour: :tags)
                          .order("count(bookings.id) desc").limit(6).group("tags.id")
                          .pluck("tags.name, count(bookings.id), tags.tour_tags_count")
    trend_tours = Booking.statistic_at(now).joins(:tour)
                         .order("count(bookings.id) desc").limit(10).group("tours.id")
                         .pluck("tours.name, count(bookings.id)")
    trend_departure = Booking.statistic_at(now).joins(:tour)
                             .order("count(bookings.id) desc").limit(10)
                             .group("tours.departure").count

    @data = {
       trend_topics: map_array(trend_topics),
       trend_tours: map(trend_tours),
       trend_departure: map(trend_departure)
      }
  end
  
  private
  
  def map_array arr
    arr.map do |item|
      {
        name: item[0],
        value1: item[1],
        value2: item[2]
      }
    end
  end
end
