#
# RegistrationsController
#
class RegistrationsController < Devise::RegistrationsController
  #
  # Create route
  #
  def create
    super
  end

  private

  # Set and sanitize sign_up params
  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  #
  # Set and sanitize account_update params
  #
  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password)
  end
end
