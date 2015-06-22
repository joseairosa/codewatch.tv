class Api::V1::LoadBalancerController < Api::V1::ApiController

  include ChannelHelper

  def stream
    if params[:app] == 'stream'
      user = User.where(username: params[:name], stream_key: params[:stream_key]).first
    else
      user = User.where(username: params[:name].split('@').first).first
    end
    response = if user
                 redirection = "rtmp://#{STREAMERS_CONFIG[user.streamer_id]['private-ip']}/#{params[:app]}/#{params[:name]}"
                 # redirection += "?#{params.to_query}"
                 redirection += "?stream_key=#{params[:stream_key]}" if params[:stream_key]
                 Rails.logger.info "Redirecting stream #{params[:name]}/#{params[:app]} to #{redirection}"
                 StatisticService.instance.load_balancer(302, ip: STREAMERS_CONFIG[user.streamer_id]['private-ip'], app: params[:app], name: params[:name])
                 {json: {response: 'ok'}, status: 302, location: redirection}
               else
                 StatisticService.instance.load_balancer(404, app: params[:app], name: params[:name])
                 {json: {response:'user_streamer_id_not_found'}, status: 404}
               end

    respond_to do |format|
      format.json { render response }
    end
  end
end
