class ExternalStreamsController < ApplicationController
  add_breadcrumb 'External Streams', :external_channels_path

  helper_method :grouped_channels
  helper_method :channel
  helper_method :display_order

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

  def grouped_channels
    @grouped_channels ||= ChannelExternal.order_by(updated_at: -1).limit(25).group_by(&:status)
  end

  def channel
    @channel
  end

  def page_options
    super.merge({page_id: 'external_streams'})
  end

  def display_order
    main_order = ['Live', 'Upcoming', 'Recording Available', 'Finished']
    main_order + (grouped_channels.keys - main_order)
  end
end
