class StatisticsData < ApplicationService
  attr_reader :data

  def initialize(data = {})
    @data = data
  end

  def call
    now = Date.today
    last = 1.month.ago
    cur_revenues = Booking.paid.sum_at(now)
    last_revenues = Booking.paid.sum_at(last)
    cur_reviews = Review.statistic_at(now).size
    last_reviews = Review.statistic_at(last).size
    cur_likes = Action.like.statistic_at(now).size
    last_likes = Action.like.statistic_at(last).size
    cur_comments = Comment.statistic_at(now).size
    last_comments = Comment.statistic_at(last).size
    users = map(User.statistic_at(now).group_by_day(:created_at).count)

    @data = {
      cur_revenues: cur_revenues,
      last_revenues: last_revenues,
      cur_reviews: cur_reviews,
      last_reviews: last_reviews,
      cur_likes: cur_likes,
      last_likes: last_likes,
      cur_comments: cur_comments,
      last_comments: last_comments,
      users: users,
      new_users: UserBlueprint.render_as_hash(User.last(7), view: :widget),
      last_bookings: BookingBlueprint.render_as_hash(Booking.last(6), view: :transaction)
    }
  end
  
  private
  
  def map data
    data.map do |key, value|
      {
        name: key,
        new: value,
      }
    end
  end
end
