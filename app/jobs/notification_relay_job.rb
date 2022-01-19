class NotificationRelayJob < ApplicationJob
  queue_as :default

  def perform notification
    ActionCable.server.broadcast("notifications:#{notification.recipient_id}_channel",
      { type: "new", notification: NotificationBlueprint.render_as_hash(notification)})
  end
end 
