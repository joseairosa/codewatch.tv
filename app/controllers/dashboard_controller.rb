class DashboardController < ApplicationController
  before_action :authenticate_user!

  attr_reader :private_session
  attr_reader :stream_keys

  add_breadcrumb 'Dashboard', :user_dashboard_path

  helper_method :channel
  helper_method :private_session
  helper_method :timezone_to_offset
  helper_method :stream_keys

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

  def stream_keys
    private_session_stream_keys = current_user.private_sessions.inject({}) do |res, ps|
      res[ps.title] = ps.stream_key
      res
    end
    @stream_keys = {
        'Current Stream Key' => current_user.stream_key
    }.merge(private_session_stream_keys)
  end

  def update_user
    @user = User.find(current_user.id)

    if @user.update(user_params)
      flash[:notice] = 'User updated'
    else
      user_input_error
    end

    redirect_to user_dashboard_path
  end

  def update_settings
    @user = User.find(current_user.id)

    can_record = params[:user] && params[:user][:can_record] ? 1 : 0

    if @user.update(can_record: can_record)
      flash[:notice] = 'Settings updated'
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
    begin
      live_at = DateTime.new(
          params['private_session']['live_at_year'].to_i,
          params['private_session']['live_at_month'].to_i,
          params['private_session']['live_at_day'].to_i,
          params['private_session']['live_at_hour'].to_i,
          params['private_session']['live_at_minute'].to_i,
          0,
          timezone_to_offset(params['private_session']['live_at_tz']))

      PrivateSession.create!(
          user: current_user,
          title: params['private_session']['title'],
          live_at: live_at,
          max_participants: params['private_session']['max_participants'],
          description: params['private_session']['description'],
          timezone: params['private_session']['live_at_tz'],
          price: params['private_session']['price'].to_f)

      flash[:notice] = 'Private session created successfully'
    rescue ArgumentError => e
      flash[:alert] = 'Go live date is Invalid'
    rescue Mongoid::Errors::Validations => e
      flash[:alert] = 'Go live date is cannot be in the past'
    end
    redirect_to user_dashboard_private_sessions_path
  end

  def edit_private_session
    @private_session = PrivateSession.where(user: current_user, token: params[:id]).first
  end

  def update_private_session
    private_session = PrivateSession.where(user: current_user, token: params[:id]).first
    if private_session
      begin
        live_at = DateTime.new(
            params['private_session']['live_at_year'].to_i,
            params['private_session']['live_at_month'].to_i,
            params['private_session']['live_at_day'].to_i,
            params['private_session']['live_at_hour'].to_i,
            params['private_session']['live_at_minute'].to_i,
            0,
            timezone_to_offset(params['private_session']['live_at_tz']))

        private_session.update!(
            title: params['private_session']['title'],
            live_at: live_at,
            max_participants: params['private_session']['max_participants'],
            description: params['private_session']['description'],
            timezone: params['private_session']['live_at_tz'],
            price: params['private_session']['price'].to_f)

        flash[:notice] = 'Private session changed successfully'
        redirect_to user_dashboard_private_sessions_path
      rescue ArgumentError => e
        flash[:alert] = 'Go live date is Invalid'
        redirect_to user_dashboard_private_sessions_edit_path(private_session.id)
      rescue Mongoid::Errors::Validations => e
        flash[:alert] = 'Go live date is cannot be in the past'
        redirect_to user_dashboard_private_sessions_edit_path(private_session.id)
      end
    else
      flash[:error] = 'Could not find session'
      redirect_to user_dashboard_private_sessions_path
    end
  end

  def cancel_private_session
    private_session = PrivateSession.where(user: current_user, token: params[:id]).first
    if private_session
      private_session.update(status: :cancelled)
      flash[:notice] = 'Cancelled successfully'
    else
      flash[:error] = 'Could not find session'
    end
    redirect_to user_dashboard_private_sessions_path
  end

  def channel
    current_user.channel
  end

  private

  def timezone_to_offset(string)
    ActiveSupport::TimeZone.all.find { |tz| tz.to_s == string }.formatted_offset
  end

  def user_params
    # NOTE: Using `strong_parameters` gem
    params.required(:user).permit(:email, :username, :current_password, :password, :password_confirmation, :timezone)
  end

  def user_input_error
    flash[:alert] = @user.errors.full_messages.first
  end

  def page_options
    super.merge({page_id: 'dashboard'})
  end
end
