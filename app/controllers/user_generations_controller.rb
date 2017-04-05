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

    set_temp_password
    set_admin

    save_user
  end

  private

  #
  # User generation params
  #
  def user_generation_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end

  #
  # Set temporary password
  # TODO: remove after test run!
  #
  def set_temp_password
    return if @user.first_name.empty? || @user.last_name.empty?
    @user.password = "excella-feedback-#{@user.first_name[0] + @user.last_name}"
  end

  #
  # Set admin
  #
  def set_admin
    @user.is_admin = false
  end

  #
  # Save user
  #
  def save_user
    if @user.save
      flash[:success] = success_message(@user, :create)
      redirect_to new_user_generation_path
    else
      flash[:error] = error_message(@user, :create)
      render :new
    end
  end
end
