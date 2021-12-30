class ValidCheckout < ApplicationService
  attr_reader :tour, :num

  def initialize(tour, num)
    @tour = tour
    @num = num
  end

  def call
    cur = @tour.quantity + @num
    return false if @tour.limit < cur
    true
  end
end
