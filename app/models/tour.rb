# == Schema Information
#
# Table name: tours
#
#  id            :bigint           not null, primary key
#  kind          :integer
#  name          :string
#  description   :text
#  time          :string
#  limit         :integer
#  departure_day :datetime
#  terminal_day  :datetime
#  price         :decimal(9, 2)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Tour < ApplicationRecord
  include Rails.application.routes.url_helpers
  paginates_per Settings.tours_per
  enum kind: { single: 1, fixed: 2 }, _suffix: :tour
  
  has_many_attached :images, dependent: :destroy

  validates :name, presence: true, length: { maximum: 255}
  validates :price, presence: true
  validates :limit, presence: true, if: :fixed_tour?
  validates :departure_day, presence: true, if: :fixed_tour?
  validates :terminal_day, presence: true,
                           if: :fixed_tour?
  validates :time, presence: true, format:  /\A\d+\-\d+\z/, if: :single_tour?
  validates :images, attached: true,
                     content_type: [:png, :jpg, :jpeg, :gif],
                     size:         { less_than: 45.megabytes},
                     limit:        { min: 1, max: 9}

  def details
    case self.kind
    when "single"
      { time: self.time }
    when "fixed"
      { 
        limit: self.limit,
        departure_day: self.departure_day,
        terminal_day: self.terminal_day
      }
    else
      return
    end
  end

  def images_data
    return unless self.images.attached?

    self.images.map{|img| ({ image: url_for(img) })}
  end
end
