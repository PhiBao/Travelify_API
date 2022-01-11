class AnalyticsData < ApplicationService
  attr_reader :data

  def initialize(data = {})
    @data = data
  end

  def call
    bookers = Booking.statistic_at(Date.today).joins(tour: :tags)
                   .group("tags.name").count
    tours = bookers.dup
    tours.each { |k, v| tours[k] = Tag.find_by(name: k).tour_tags_count }

    @data = {
       trend_topics: map(bookers),
       topic_tours: map(tours)
      }
  end
  
  private
  
  def map data
    data.map do |key, value|
      {
        name: key,
        value: value,
      }
    end
  end
end
