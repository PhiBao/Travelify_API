class NotificationsController < ApplicationController
  before_action :admin_user, only: %i[index destroy]
  before_action :logged_in_user, only: :update
  before_action :load_notification, only: %i[update destroy]

  def index
    render json: { reports: { list: NotificationBlueprint
                                    .render_as_hash(Notification.reported.seriously, view: :admin),
                            } }, status: 200
  end

  def update    
    if @notification.unread?
      @notification.update_column(:status, "watched")
    end

    render json: { id: @notification.id }, status: 200
  end

  def destroy
    Notification.transaction do
      Action.transaction do
        Action.report.where(target: @notification.notifiable).delete_all
        @notification.destroy!

        render json: { id: @notification.id }, status: 200
      end
    end
  end

  private
  
  def load_notification
    @notification = Notification.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { messages: ['Notification not found'] }, status: 404
  end
end
