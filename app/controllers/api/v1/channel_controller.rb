class Api::V1::ChannelController < Api::V1::ApiController

  include ChannelHelper

  def like
    user = current_user
    response = if user
                 channel_owner = User.where(username: params[:channel_id]).first
                 if channel_owner
                   ChannelService.instance.like(channel_owner.channel, user)
                   {json: {response:'ok'}, status: 200}
                 else
                   {json: {response:'channel_not_found'}, status: 404}
                 end
               else
                 {json: {response:'must_be_logged_in'}, status: 401}
               end
    respond_to do |format|
      format.json { render response }
    end
  end

  def unlike
    user = current_user
    response = if user
                 channel_owner = User.where(username: params[:channel_id]).first
                 if channel_owner
                   ChannelService.instance.unlike(channel_owner.channel, user)
                   {json: {response:'ok'}, status: 200}
                 else
                   {json: {response:'channel_not_found'}, status: 404}
                 end
               else
                 {json: {response:'must_be_logged_in'}, status: 401}
               end
    respond_to do |format|
      format.json { render response }
    end
  end
end
