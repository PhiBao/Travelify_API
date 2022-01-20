class NotificationBlueprint < Blueprinter::Base
  identifier :id
  fields :action, :notifiable_type, :tour_id, :status, :others, :created_at
  association :user, blueprint: UserBlueprint, view: :short  
end
