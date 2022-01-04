# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  commentable_type :string
#  commentable_id   :integer
#  body             :text
#  state            :boolean          default("true")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_comments_on_commentable_id_and_commentable_type  (commentable_id,commentable_type)
#  index_comments_on_user_id                              (user_id)
#

class Comment < ApplicationRecord
  paginates_per Settings.comments_per
  enum state: { appear: true, hide: false }

  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :actions, as: :target, dependent: :destroy
  has_many :replies, class_name: 'Comment', as: :commentable, dependent: :destroy

  validates :body, presence: true, length: { maximum: 1000}

  def likes
    self.actions.like.size
  end
end
