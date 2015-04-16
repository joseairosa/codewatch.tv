class ChannelController < ApplicationController
  def show
    @channel_id = params[:id]
  end

  def channel_id
    @channel_id
  end

  helper_method :channel_id
end