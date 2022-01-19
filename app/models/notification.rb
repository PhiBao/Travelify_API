# == Schema Information
#
# Table name: notifications
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  recipient_id    :integer
#  action          :string
#  notifiable_type :string
#  notifiable_id   :integer
#  status          :boolean          default("false")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_notifications_on_notifiable_type_and_notifiable_id  (notifiable_type,notifiable_id)
#  index_notifications_on_recipient_id                       (recipient_id)
#  index_notifications_on_user_id                            (user_id)
#

class Notification < ApplicationRecord
  paginates_per Settings.notifications_per
  enum status: { unread: false, watched: true}
  belongs_to :user
  belongs_to :recipient, class_name: :User
  belongs_to :notifiable, polymorphic: true

  after_create :send_notification

  def send_notification
    NotificationRelayJob.perform_now(self)
  end

  def tour_id
    if self.notifiable_type == 'Review'
      return self.notifiable.booking.tour_id
    else
      curr = self.notifiable
      while curr.commentable_type != "Review"
        curr = cur.commentable
      end
      return curr.booking.tour_id
    end
  end
end
