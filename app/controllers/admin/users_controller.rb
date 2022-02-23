module Admin
  class UsersController < AdminController
    include UsersHelper
    before_action :load_user_by_id, only: %i[update destroy]
    
    def index
      render json: { users: { list: UserBlueprint.render_as_hash(User.normal, view: :admin),
                              type: "users" } }, status: 200
    end

    def update
      if update_user_params[:email] && (update_user_params[:email].downcase != @user.email)
        user_obj = update_user_params.merge(activated: true, activated_at: Time.now)
      else
        user_obj = update_user_params
      end
  
      if @user.update(user_obj)
        render json: UserBlueprint.render(@user, root: :user, view: :admin), status: 200
      else
        render json: { messages: @user.errors.full_messages }, status: 400
      end
    end

    def destroy
      User.transaction do
        Review.transaction do
          Comment.transaction do
            Comment.where(user: @user).delete_all
            Review.where(booking: @user.bookings).delete_all
            if @user.destroy
              render json: { id: @user.id }
            else
              render json: { messages: @user.errors.full_messages }, status: 400
            end
          end
        end
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
  end
end
