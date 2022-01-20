class SessionsController < ApplicationController
  before_action :load_user_by_email, only: :create

  def create
    if @user&.authenticate(session_params[:password])
      payload = { id: @user.id,
                  admin: @user.admin }
      token = encode(payload)
      render json: { token: token, user: UserBlueprint.render_as_hash(@user, view: :full),
                     remember_me: session_params[:remember_me],
                     list: NotificationBlueprint.render_as_hash(@user.notifications.newest.page(1)),
                     unread: @user.notifications.unread.size,
                     all: @user.notifications.size }, status: 200
    else
      render json: { messages: ['Invalid password'] }, status: 400
    end
  end

  def social_create
    @user = User.from_omniauth(social_params)
    payload = { id: @user.id,
                admin: @user.admin }
    token = encode(payload)
    if @user.persisted?
      render json: { token: token, user: UserBlueprint.render_as_hash(@user, view: :full),
                     list: NotificationBlueprint.render_as_hash(@user.notifications.newest.page(1)),
                     unread: @user.notifications.unread.size,
                     all: @user.notifications.size }, status: 200
    else
      render json: { messages: ['Can not login, please try again'], status: 400 }
    end
  end

  private

  def session_params
    params.require(:user).permit(:email, :password, :remember_me)
  end

  def social_params
    params.permit(:provider, :uid, info: [:email, :first_name, :last_name, :avatar])
  end
end
