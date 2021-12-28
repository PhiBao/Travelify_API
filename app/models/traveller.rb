# == Schema Information
#
# Table name: travellers
#
#  id           :integer          not null, primary key
#  booking_id   :integer
#  name         :string
#  email        :string
#  phone_number :string
#  note         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Traveller < ApplicationRecord
  belongs_to :booking

  validates :booking_id, presence: true
  validates :name, presence: true
  VALID_EMAIL_REGEX = /\A^(|(([A-Za-z0-9]+_+)|(\+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})\z/
  validates :email, presence: true, format: VALID_EMAIL_REGEX
  validates :phone_number, numericality: { only_integer: true },
                           length: { minimum: 9, maximum: 11 },
                           presence: true
  validats :note, length: { maximum: 500}
end
