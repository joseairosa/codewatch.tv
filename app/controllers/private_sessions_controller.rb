class PrivateSessionsController < ApplicationController

  attr_reader :private_session

  helper_method :private_session
  helper_method :channel_id
  helper_method :is_channel_owner?
  helper_method :is_channel_moderator?

  include ChannelHelper

  QUALITIES = %w(180p 360p 720p)

  def show
    private_session = PrivateSession.find(params[:id])
    return redirect_to '/404' if private_session.nil? || params[:id].empty?
    @private_session = private_session
  end

  private

  def channel_id
    private_session.token
  end

  def page_options
    super.merge({page_id: 'channel'})
  end
end
