module Admin
  class UsersController < AdminController
    before_action :load_user_by_id, only: :destroy
    
    def index
      render json: { users: { list: UserBlueprint.render_as_hash(User.normal, view: :admin),
                              type: "users" } }, status: 200
    end

    def destroy
      if @user.destroy
        render json: { id: @user.id }
      else
        render json: { messages: @user.errors.full_messages }, status: 400
      end
    end

    def create
      user = User.new(user_params)
  
      if user.save
        user.activate
        render json: UserBlueprint.render(user, root: :user, view: :admin), status: 201
      else 
        render json: { messages: user.errors.full_messages }, status: 404
      end
    end

    private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation,
                                  :address, :phone_number, :birthday)
    end
  end
end
