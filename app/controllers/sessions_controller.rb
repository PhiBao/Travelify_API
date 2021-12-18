class SessionsController < ApplicationController
  before_action :load_user_by_email, only: [:create]

  def create
    if @user&.authenticate(session_params[:password])
      payload = { id: @user.id}
      token = encode(payload)
      render json: { token: token, user: UserBlueprint.render(@user),
                     remember_me: session_params[:remember_me] }, status: 200
    else
      render json: { messages: ['Invalid password'] }, status: 400
    end
  end

  def social_create
    @user = User.from_omniauth(social_params)
    payload = { id: @user.id}
    token = encode(payload)
    if @user.persisted?
      render json: { token: token, user: UserBlueprint.render(@user) }, status: 200
    else
      render json: { messages: ['Can not login, please try again'], status: 400}
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
