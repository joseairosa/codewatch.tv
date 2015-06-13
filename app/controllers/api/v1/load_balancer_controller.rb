class Api::V1::LoadBalancerController < Api::V1::ApiController

  include ChannelHelper

  def stream
    user = User.where(username: params[:name], stream_key: params[:stream_key]).first
    response = if user
                 {json: {response: 'ok'}, status: 302, location: "rtmp://#{STREAMERS_CONFIG[user.streamer_id]['ip']}/#{params[:app]}/#{params[:name]}?stream_key=#{params[:stream_key]}"}
               else
                 {json: {response:'user_streamer_id_not_found'}, status: 404}
               end

    respond_to do |format|
      format.json { render response }
    end
  end
end
