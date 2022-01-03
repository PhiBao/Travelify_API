# == Schema Information
#
# Table name: reviews
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  tour_id    :integer
#  hearts     :integer
#  body       :text
#  state      :boolean          default("true")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_reviews_on_tour_id  (tour_id)
#  index_reviews_on_user_id  (user_id)
#

class Review < ApplicationRecord
  paginates_per Settings.reviews_per
  enum state: { appear: true, hide: false }

  belongs_to :user
  belongs_to :tour
  has_many :actions, as: :target, dependent: :destroy

  validates :hearts, presence: true
  validates :body, length: { maximum: 2000 }

  def likes
    self.actions.like.size
  end
end
