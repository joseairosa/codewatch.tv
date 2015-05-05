class HomeController < ApplicationController
  include ChannelHelper

  helper_method :featured_channels
  helper_method :featured_streamers

  def index
  end

  private

  def featured_channels
    first_channel = Channel.first
    [first_channel, first_channel, first_channel]
  end

  def featured_streamers
    first_user = User.first
    [first_user, first_user, first_user]
  end
end
