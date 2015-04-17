class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
  end

  def edit_channel
    if request.post?
      category = Category.where(name: params['channel']['category']).first
      if category
        current_user.channel.update_attributes(category: category, title: params['channel']['title'], description: params['channel']['description'])
        flash[:notice] = 'Channel updated'
      else
        flash[:alert] = 'Cannot find that category'
      end
      redirect_to edit_user_channel_path
    end
  end

  def update_user
    @user = User.find(current_user.id)

    if @user.update(user_params)
      flash[:notice] = "User updated."
    else
      user_input_error
    end

    redirect_to user_dashboard_path
  end

  def update_password
    @user = User.find(current_user.id)

    if @user.update_with_password(user_params) && !params[:user][:password].blank?
      flash[:notice] = "Password updated."
      # Sign in the user by passing validation in case their password changed
      sign_in @user, :bypass => true
    else
      @user.errors[:password] << t('errors.messages.blank') if params[:user][:password].blank?
      user_input_error
    end

    redirect_to user_dashboard_path
  end

  def channel
    current_user.channel
  end

  helper_method :channel

  private

  def user_params
    # NOTE: Using `strong_parameters` gem
    params.required(:user).permit(:email, :current_password, :password, :password_confirmation)
  end

  def user_input_error
    flash[:alert] = @user.errors.full_messages.first
  end
end
