class ChannelController < ApplicationController

  helper_method :channel
  helper_method :channel_id

  def show
    user = User.where(username: params[:username]).first
    redirect_to '/404' if user.nil? || params[:username].empty?
    @channel = user.channel
    @channel_id = params[:id]
  end

  def index
    @category = Category.find(params[:category_id])
    @channels = @category.channels
  end

  private

  def channel_id
    channel.user.username
  end

  def channel
    @channel
  end


end
