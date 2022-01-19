class NotificationsController < ApplicationController
  before_action :logged_in_user
  before_action :load_notification, only: :update

  def update    
    if @notification.unread?
      @notification.watched!
    end
  end

  private
  
  def load_notification
    @notification = Notification.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { messages: ['Notification not found'] }, status: 404
  end
end
