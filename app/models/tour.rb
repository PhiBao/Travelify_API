# == Schema Information
#
# Table name: tours
#
#  id          :integer          not null, primary key
#  kind        :integer
#  name        :string
#  description :text
#  time        :string
#  quantity    :decimal(3, 1)    default("0.0")
#  limit       :integer
#  begin_date  :datetime
#  return_date :datetime
#  price       :decimal(9, 2)
#  departure   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Tour < ApplicationRecord
  include Rails.application.routes.url_helpers
  paginates_per Settings.tours_per
  enum kind: { single: 1, fixed: 2 }
  
  has_many_attached :images, dependent: :destroy
  has_many :tour_vehicles, dependent: :destroy
  has_many :vehicles, through: :tour_vehicles
  has_many :tour_tags, dependent: :destroy
  has_many :tags, through: :tour_tags
  has_many :bookings, dependent: :nullify
  has_many :actions, as: :target, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :name, presence: true, length: { maximum: 255}
  validates :departure, presence: true
  validates :price, presence: true, numericality: { greater_than: 0, less_than: 1000000 }
  validates :limit, presence: true, if: :fixed?
  validates :begin_date, presence: true, if: :fixed?
  validates :return_date, presence: true, 
                          comparison: { greater_than_or_equal_to: 
                            Proc.new { |obj| obj.begin_date + 6.hours },
                          message: "Return date must be greater six hours than begin date"},
                          if: :fixed?
  validates :time, presence: true, format:  /\A\d+\-\d+\z/, if: :single?
  validates :images, content_type: [:png, :jpg, :jpeg, :gif],
                     size: { less_than: 45.megabytes }, limit: { max: 9 }
  scope :valid, -> { where("kind = 1 OR begin_date >= ?", Time.zone.now) }
  scope :hot, -> { left_joins(:bookings).group("tours.id").order('sum(bookings.total) desc') }
  scope :favorite, -> { left_joins(:reviews).group("tours.id").order('sum(reviews.hearts) desc') }
  
  # Accept nested attributes
  def tour_tags_attributes=(array)
    array.each do |item|
      if item[:_destroy]
        tour_tags.find(item[:id]).destroy
      else
        tour_tags.build(item)
      end
    end
  end

  def tour_vehicles_attributes=(array)
    array.each do |item|
      if item[:_destroy]
        tour_vehicles.find(item[:id]).destroy
      else
        tour_vehicles.build(item)
      end
    end
  end

  # Serializers
  def details
    case self.kind
    when "single"
      { time: self.time }
    when "fixed"
      { 
        quantity: self.quantity,
        limit: self.limit,
        begin_date: self.begin_date,
        return_date: self.return_date
      }
    else
      return
    end
  end

  def images_data
    return unless self.images.attached?
    
    self.images.map{ |img| (url_for(img)) }
  end

  def vehicles_data
    return [] if self.vehicles.size == 0

    self.vehicles.map{ |vehicle| vehicle.name }
  end

  def tags_data
    return [] if self.tags.size == 0

    self.tags.map{ |tag| tag.name }
  end

  def rate
    return 0 unless self.reviews.size > 0
    self.reviews.sum(:hearts) / self.reviews.size
  end
end
