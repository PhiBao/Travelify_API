# == Schema Information
#
# Table name: tags
#
#  id   :integer          not null, primary key
#  name :string
#
# Indexes
#
#  index_tags_on_name  (name)
#

class Tag < ApplicationRecord
  has_many :tour_tags, dependent: :destroy
  has_many :tours, through: :tour_vehicles

  validates :name, presence: true, uniqueness: true
end
