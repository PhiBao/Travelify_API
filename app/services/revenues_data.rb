class RevenuesData < ApplicationService
  attr_reader :data

  def initialize(data = {})
    @data = data
  end

  def call
    current = Booking.paid.statistic_at(Date.today).group_by_day(:updated_at).sum(:total)
    other = Booking.paid.statistic_at(1.month.ago).group_by_day(:updated_at).sum(:total)

    @data = {
      current: map(current),
      other: map(other)
      }
  end
end
