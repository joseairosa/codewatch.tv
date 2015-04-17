class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
  end

  def edit_channel

  end

  def update_user
    @user = User.find(current_user.id)

    if @user.update(user_params)
      # Sign in the user by passing validation in case their password changed
      sign_in @user, :bypass => true
      redirect_to user_dashboard_path
    else
      render "edit"
    end
  end

  def channel
    current_user.channel
  end

  helper_method :channel

  private

  def user_params
    # NOTE: Using `strong_parameters` gem
    params.required(:user).permit(:email)
  end
end
