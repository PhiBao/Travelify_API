module UsersHelper
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation,
                                 :address, :phone_number, :birthday)
  end

  def update_user_params
    params.permit(:first_name, :last_name, :email, :address, :phone_number, :birthday, :avatar)
  end
end
