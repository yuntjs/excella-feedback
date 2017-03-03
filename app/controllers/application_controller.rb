class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

    def authenticate_admin
      unless current_user && current_user.is_admin
        redirect_to presentations_path
      end
    end

    def success_message(object, action)
      "#{object.class.name} has been successfully #{action.to_s}d."
    end

    def error_message(object, action)
      "We ran into some errors while trying to #{action.to_s} this #{object.class.name.downcase}. Please try again."
    end
end
