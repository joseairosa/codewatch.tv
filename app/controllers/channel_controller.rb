class ChannelController < ApplicationController

  attr_reader :channel

  helper_method :channel
  helper_method :channel_id
  helper_method :is_channel_owner?
  helper_method :is_channel_moderator?
  helper_method :is_channel_subscriber?

  include ChannelHelper

  QUALITIES = %w(180p 360p 720p)

  def show
    user = User.where(username: params[:username]).first
    return redirect_to '/404' if user.nil? || params[:username].empty?
    @channel = user.channel
    @channel_id = params[:id]
  end

  private

  def channel_id
    channel.user.username
  end

  def page_options
    super.merge({page_id: 'channel'})
  end
end
