require 'open-uri'

class ChannelController < ApplicationController

  helper_method :channel
  helper_method :channel_id
  helper_method :current_viewers

  def show
    user = User.where(username: params[:username]).first
    redirect_to '/404' if user.nil? || params[:username].empty?
    @channel = user.channel
    @channel_id = params[:id]
  end

  private

  def current_viewers
    URI.parse("http://streamer-01.codewatch.tv/subscriberss?app=stream&name=#{channel.user.username}").read.delete("\n")
  end

  def channel_id
    channel.user.username
  end

  def channel
    @channel
  end
end
