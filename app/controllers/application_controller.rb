class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def authenticate_admin
    # current_user.is_admin
    true
  end

end
