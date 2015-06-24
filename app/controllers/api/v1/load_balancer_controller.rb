class Api::V1::LoadBalancerController < Api::V1::ApiController

  include ChannelHelper

  def stream
    @stream_name, @quality = params[:name].split('@')

    user = if @stream_name.start_with?('PS-')
             if params[:app] == 'stream'
               PrivateSession.where(token: @stream_name, stream_key: params[:stream_key]).first.try(:user)
             else
               PrivateSession.where(token: @stream_name).first.try(:user)
             end
           else
             if params[:app] == 'stream'
               User.where(username: @stream_name, stream_key: params[:stream_key]).first
             else
               User.where(username: @stream_name).first
             end
           end

    response = if user
                 redirection = "rtmp://#{STREAMERS_CONFIG[user.streamer_id]['private-ip']}/#{params[:app]}/#{@stream_name}"
                 # redirection += "?#{params.to_query}"
                 redirection += "?stream_key=#{params[:stream_key]}" if params[:stream_key]
                 Rails.logger.info "Redirecting stream #{@stream_name}/#{params[:app]} to #{redirection}"
                 StatisticService.instance.load_balancer(302, ip: STREAMERS_CONFIG[user.streamer_id]['private-ip'], app: params[:app], name: @stream_name)
                 {json: {response: 'ok'}, status: 302, location: redirection}
               else
                 StatisticService.instance.load_balancer(404, app: params[:app], name: @stream_name)
                 {json: {response:'user_streamer_id_not_found'}, status: 404}
               end

    respond_to do |format|
      format.json { render response }
    end
  end
end
