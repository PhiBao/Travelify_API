class NotificationRelayJob < ApplicationJob
  queue_as :default

  def perform notification
    ActionCable.server.broadcast("notifications:#{notification.recipient_id}_channel",
                NotificationBlueprint.render_as_hash(notification, root: :notification, view: :normal))
  end
end 
