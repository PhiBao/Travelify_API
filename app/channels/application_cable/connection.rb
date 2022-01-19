module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user  
      id = request.params[:id]
      user = User.find_by_id(id)
      if user.present?
        user
      else
        reject_unauthorized_connection
      end
    end
  end
end
