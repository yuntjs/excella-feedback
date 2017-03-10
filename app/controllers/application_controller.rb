#
# ApplicationController
#
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  #
  # Protect admin-only paths
  #
  def authenticate_admin
    return if current_user && current_user.is_admin
    redirect_to presentations_path
  end

  #
  # Define success message for notices
  #
  def success_message(object, action)
    "#{object.class.name} has been successfully #{action}d."
  end

  #
  # Define error message for notices
  #
  def error_message(object, action)
    "We ran into some errors while trying to #{action} this"\
    " #{object.class.name.downcase}. Please try again."
  end
end
