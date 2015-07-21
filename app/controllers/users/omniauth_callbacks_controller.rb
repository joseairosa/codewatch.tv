class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def reddit
    process_callback(:reddit, 'Reddit')
  end

  def twitchtv
    process_callback(:twitchtv, 'Twitch')
  end

  def facebook
    process_callback(:facebook, 'Facebook')
  end

  def process_callback(provider, realname)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.nil?
      flash[:alert] = 'Your account is already linked with other provider.'
      redirect_to new_user_session_path and return
    end

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => realname) if is_navigational_format?
      flash[:notice] << "Please don't forget to change your username." if @user.email == @user.username
    else
      session["devise.#{provider.to_s}_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_path
    end
  end
end
