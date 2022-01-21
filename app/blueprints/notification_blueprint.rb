class NotificationBlueprint < Blueprinter::Base
  identifier :id
  fields :notifiable_type, :updated_at

  view :normal do
    fields :tour_id, :status, :others, :action
    association :user, blueprint: UserBlueprint, view: :short
  end

  view :admin do
    field :notifiable_id
    field :body do |notification|
      notification.notifiable.body
    end
    field :size do |notification|
      notification.others + 1
    end
    field :state do |notification|
      notification.notifiable.state
    end
    field :reason do |notification|
      Action.report.where(target: notification.notifiable).map(&:content).join("<br>")
    end
  end
end
