class ChannelController < ApplicationController

  helper_method :channel
  helper_method :channel_id
  helper_method :current_viewers

  QUALITIES = %w(180p 360p 720p)

  def show
    user = User.where(username: params[:username]).first
    redirect_to '/404' if user.nil? || params[:username].empty?
    @channel = user.channel
    @channel_id = params[:id]
  end

  private

  def current_viewers
    @current_viewers ||= begin
      nviewers = ChannelService.instance.number_viewers(channel)
      # That's you :)
      nviewers = 1 if nviewers == 0
      nviewers
    end
  end

  def channel_id
    channel.user.username
  end

  def channel
    @channel
  end
end
