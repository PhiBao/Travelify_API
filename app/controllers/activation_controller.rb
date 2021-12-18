class ActivationController < ApplicationController
  before_action :load_user_by_id, only: [:show]
  before_action :load_user_by_email, only: [:update]
  before_action :valid_user, only: [:update]

  def show
    if @user.activated?
      render json: { messages: ["User has been activated"] }, status: 400
    else
      @user.create_activation_digest
      @user.send_activation_email
      render json: { ok: true }, status: 200
    end
  end

  def update
    if @user.activate                  
      @user.update(activation_digest: nil)
      render json: { ok: true }, status: 200
    else
      render json: { messages: ["Something go wrong, please try again"] }, status: 400
    end
  end

  private

  def valid_user
    unless (@user && !@user.activated? && @user.authenticated?(:activation, params[:id]))
      render json: { messages: ["User is invalid, please try again later"] }, status: 400
    end
  end
end
