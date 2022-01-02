# == Schema Information
#
# Table name: actions
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  scope       :integer
#  target_type :string
#  target_id   :integer
#  data        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_actions_on_target_type_and_target_id  (target_type,target_id)
#  index_actions_on_user_id                    (user_id)
#

class Action < ApplicationRecord
  enum scope: { like: 1, dislike: 2, rating: 3, mark: 4 }

  belongs_to :target, polymorphic: true
  belongs_to :user

  validates :user_id, presence: true
  validates :scope, presence: true
  validates :target_type, presence: true
  validates :target_id, presence: true
  validates :data, presence: true, if: :rating?
end
