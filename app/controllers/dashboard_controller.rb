class DashboardController < ApplicationController
  before_action :authenticate_user!

  add_breadcrumb 'Dashboard', :user_dashboard_path

  def index
    add_breadcrumb 'Profile', :user_dashboard_path
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

  def chat_management
    add_breadcrumb 'Chat Management', :user_dashboard_chat_management_path
    @banned_users = current_user.channel.chat.users_banned
    @moderator_users = current_user.channel.chat.users_moderator
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

  def update_settings
    @user = User.find(current_user.id)

    can_record = params[:user] && params[:user][:can_record] ? 1 : 0

    if @user.update(can_record: can_record)
      flash[:notice] = "Settings updated."
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

  def show_hide_vod
    @recording = Recording.find(params[:id])

    if @recording
      @recording.toggle_visibility
      flash[:notice] = 'VoD hidden successfully'
    else
      flash[:alert] = 'Cannot find that VoD'
    end

    redirect_to user_dashboard_path
  end

  def delete_vod
    @recording = Recording.find(params[:id])

    if @recording
      @recording.delete
      flash[:notice] = 'VoD deleted successfully'
    else
      flash[:alert] = 'Cannot find that VoD'
    end

    redirect_to user_dashboard_path
  end

  def private_sessions
    @private_sessions = current_user.private_sessions
  end

  def create_private_session

  end

  def edit_private_session

  end

  def update_private_session

  end

  def channel
    current_user.channel
  end

  helper_method :channel

  private

  def user_params
    # NOTE: Using `strong_parameters` gem
    params.required(:user).permit(:email, :username, :current_password, :password, :password_confirmation)
  end

  def user_input_error
    flash[:alert] = @user.errors.full_messages.first
  end

  def page_options
    super.merge({page_id: 'dashboard'})
  end
end
