# == Schema Information
#
# Table name: vehicles
#
#  id   :integer          not null, primary key
#  name :string
#
# Indexes
#
#  index_vehicles_on_name  (name)
#

class Vehicle < ApplicationRecord
  has_many :tour_vehicles, dependent: :destroy
  has_many :tours, through: :tour_vehicles

  validates :name, presence: true, uniqueness: true
end
