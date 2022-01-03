# == Schema Information
#
# Table name: tags
#
#  id              :integer          not null, primary key
#  name            :string
#  tour_tags_count :integer          default("0")
#
# Indexes
#
#  index_tags_on_name  (name)
#

class Tag < ApplicationRecord
  include Rails.application.routes.url_helpers
  has_many :tour_tags, dependent: :destroy
  has_many :tours, through: :tour_vehicles

  has_one_attached :illustration, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :illustration, content_type: [:png, :jpg, :jpeg, :gif],
                           size:         { less_than: 5.megabytes }

  scope :popularity, -> { order(tour_tags_count: :desc) }                        

  def illustration_url
    return unless self.illustration.attached?
    url_for(self.illustration)
  end
end
