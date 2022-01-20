class UsersController < ApplicationController
  include UsersHelper
  before_action :load_user_by_email, only: :reset_password
  before_action :correct_user, only: %i[show update change_password bookings read_all]
  before_action :valid_user, only: :reset_password
  before_action :check_expiration, only: :reset_password
  
  def create
    user = User.new(user_params)

    if user.save
      payload = { id: user.id,
                  admin: user.admin }
      token = encode(payload)
      user.create_activation_digest
      user.send_activation_email
      render json: { user: UserBlueprint.render_as_hash(user, view: :full),
                     token: token }, status: 201
    else 
      render json: { messages: user.errors.full_messages }, status: 404
    end
  end

  def show
    render json: { user: UserBlueprint.render_as_hash(@user, view: :full),
                   list: NotificationBlueprint.render_as_hash(current_user.notifications.newest.page(1)),
                   unread: current_user.notifications.unread.size,
                   all: current_user.notifications.size }, status: 200
  end

  def update
    if update_user_params[:email] && (update_user_params[:email].downcase != @user.email)
      user_obj = update_user_params.merge(activated: false)
    else
      user_obj = update_user_params
    end

    if @user.update(user_obj)
      render json: UserBlueprint.render(@user, root: :user, view: :full), status: 200
    else
      render json: { messages: @user.errors.full_messages }, status: 400
    end
  end

  def forgotten_password
    email = params[:email]
    if email.blank?
      return render json: { messages: ['Email not present'] }, status: 400
    end

    user = User.find_by(email: email.downcase)

    if user&.activated?
      user.create_reset_digest
      user.send_password_reset_email
      render json: { email: user.email }, status: 200
    else
      render json: { messages: ['Email address invalid. Please check and try again.'] }, status: 404
    end
  end

  def reset_password
    if reset_password_params[:password].empty?                  
      render json: { messages: ["password is empty"] }, status: 400
    elsif @user.update(reset_password_params)                    
      @user.update(reset_password_digest: nil)
    else
      render json: { messages: ["password is invalid"] }, status: 400
    end
  end

  def change_password
    if @user.authenticate(change_password_params[:current_password])
      if (change_password_params[:new_password] != 
          change_password_params[:password_confirmation])
        render json: { messages: ["Password and password confirmation is not the same."] }, status: 400
      else
        unless @user.update(password: change_password_params[:new_password])
          render json: { messages: ["Password is invalid."] }, status: 400
        end
      end
    else
      render json: { messages: ["Current password is incorrect."] }, status: 400
    end
  end

  def bookings
    page = params[:page] || 1
    case params[:status]
    when "confirming"
      list = current_user.bookings.confirming.newest
    when "paid"
      list = current_user.bookings.paid.newest
    when "canceled"
      list = current_user.bookings.canceled.newest
    else
      list = current_user.bookings.newest
    end

    render json: BookingBlueprint.render(list.page(page), root: :list,
                                         view: :history, meta: { total: list.length })
  end

  def notifications
    page = params[:page] || 1
    render json: NotificationBlueprint.render(current_user.notifications.newest.page(page), root: :list), status: 200
  end

  def read_all
    @user.notifications.update_all(status: "watched")
  end
  
  private

  def reset_password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def change_password_params
    params.require(:data).permit(:current_password, :new_password, :password_confirmation)
  end

  def valid_user
    unless (@user&.activated? && @user.authenticated?(:reset_password, params[:id]))
      render json: { messages: ["User is invalid, please try again later"] }, status: 400
    end
  end
  
  # Checks expiration of reset token.
  def check_expiration
    if @user.password_reset_expired?
      render json: { messages: ["The token has expired, please try again"] }, status: 400
    end
  end
end
