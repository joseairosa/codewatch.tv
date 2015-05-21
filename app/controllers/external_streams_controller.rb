class ExternalStreamsController < ApplicationController
  add_breadcrumb 'External Streams', :external_channels_path

  helper_method :offline_channels
  helper_method :online_channels
  helper_method :channel

  def index
    add_breadcrumb 'All', :external_channels_path
  end

  def show
    user = UserExternal.where(username: params[:username]).first
    return redirect_to '/404' if user.nil? || params[:username].empty?
    add_breadcrumb user.username, user_external_channel_path(user.username)
    @channel = user.channel
  end

  private

  def online_channels
    @online_channels ||= ChannelExternal.where(status: 'Live').desc(:updated_at).limit(25)
  end

  def offline_channels
    @offline_channels ||= ChannelExternal.ne(status: 'Live').desc(:updated_at).limit(25)
  end

  def channel
    @channel
  end

  def page_options
    super.merge({page_id: 'external_streams'})
  end
end
