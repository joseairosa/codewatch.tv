class ChannelController < ApplicationController
  def show
    user = User.where(username: params[:username]).first
    redirect_to '/404' if user.nil? || params[:username].empty?
    @channel = user.channel
    @channel_id = params[:id]
  end

  def channel_id
    channel.user.username
  end

  def channel
    @channel
  end

  helper_method :channel
  helper_method :channel_id
end
