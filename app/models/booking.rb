# == Schema Information
#
# Table name: bookings
#
#  id             :integer          not null, primary key
#  tour_id        :integer
#  user_id        :integer
#  adults         :integer
#  children       :integer          default("0")
#  departure_date :datetime
#  total          :decimal(9, 2)
#  status         :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_bookings_on_tour_id  (tour_id)
#  index_bookings_on_user_id  (user_id)
#

class Booking < ApplicationRecord
  enum status: { confirming: 1, paid: 2, canceled: 3 }

  belongs_to :user, optional: true
  belongs_to :tour, optional: true
  has_one :traveller, dependent: :destroy

  validates :tour_id, presence: true, on: :create
  validates :total, presence: true
  validates :adults, presence: true
  validates :children, presence: true
  validates :departure_date, presence: true
  validates :status, presence: true

  # Create traveller while create boking
  def traveller_attributes=(hash)  
    self.build_traveller(hash)
  end

  # Send confirmed mailer
  def send_confirmed_mailer
    BookingMailer.booking_confirmed(self).deliver_now
  end
end
