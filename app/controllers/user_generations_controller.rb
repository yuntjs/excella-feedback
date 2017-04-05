#
# UserGenerationsController
#
class UserGenerationsController < ApplicationController
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
    byebug

    @user = User.new(
      first_name: params[:user][:first_name],
      last_name: params[:user][:last_name],
      email: params[:user][:email]
    )

    byebug

    redirect_to user_registration_path(@user)
  end

  private

  #
  # User generation params
  #
  def user_generation_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end
end
