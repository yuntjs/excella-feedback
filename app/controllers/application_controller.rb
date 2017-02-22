class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def authenticate_admin
    unless current_user && current_user.is_admin
      redirect_to presentations_path
    end
  end

end
