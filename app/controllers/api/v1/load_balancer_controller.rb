class Api::V1::LoadBalancerController < Api::V1::ApiController

  include ChannelHelper

  def stream
    if params[:app] == 'stream'
      user = User.where(username: params[:name], stream_key: params[:stream_key]).first
    elsif params[:app] == 'vod'
      user = User.where(username: params[:name].split('-').first).first
    else
      user = User.where(username: params[:name]).first
    end
    response = if user
                 redirection = "rtmp://#{STREAMERS_CONFIG[user.streamer_id]['private-ip']}/#{params[:app]}/#{params[:name]}"
                 redirection += "?#{params.to_query}"
                 # redirection += "?stream_key=#{params[:stream_key]}" if params[:stream_key]
                 Rails.logger.info "Redirecting stream #{params[:name]}/#{params[:app]} to #{redirection}"
                 {json: {response: 'ok'}, status: 302, location: redirection}
               else
                 {json: {response:'user_streamer_id_not_found'}, status: 404}
               end

    respond_to do |format|
      format.json { render response }
    end
  end
end
