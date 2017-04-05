#
# UserGenerationsController
#
class UserGenerationsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin

  #
  # New
  #
  def new
    @user = User.new
  end

  #
  # Create
  #
  def create
    @user = User.new(user_generation_params)

    # redirect_to user_registration_path(@user)
  end

  private

  #
  # User generation params
  #
  def user_generation_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
