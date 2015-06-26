class Api::V1::LoadBalancerController < Api::V1::ApiController

  include ChannelHelper
  include StreamerHelper

  def stream
    @stream_name, @quality = params[:name].split('@')

    user = if @stream_name.start_with?('PS-')
             private_session = if params[:app] == 'stream'
                                 PrivateSession.where(token: @stream_name, stream_key: params[:stream_key]).first
                               else
                                 PrivateSession.where(token: @stream_name).first
                               end
             if private_session
               private_session.elect_streamer if params[:app] == 'stream'
               streamer_id = private_session.streamer_id
               private_session.user
             else
               nil
             end
           else
             user = if params[:app] == 'stream'
                      User.where(username: @stream_name, stream_key: params[:stream_key]).first
                    else
                      User.where(username: @stream_name).first
                    end
             if user
               user.channel.elect_streamer if params[:app] == 'stream'
               streamer_id = user.channel.streamer_id
               user
             else
               nil
             end
           end

    response = if user
                 redirection = "rtmp://#{private_ip_for_streamer(streamer_id)}/#{params[:app]}/#{params[:name]}"
                 # redirection += "?#{params.to_query}"
                 redirection += "?stream_key=#{params[:stream_key]}" if params[:stream_key]
                 Rails.logger.info "Redirecting stream #{params[:name]}/#{params[:app]} to #{redirection}"
                 StatisticService.instance.load_balancer(302, ip: private_ip_for_streamer(streamer_id), app: params[:app], name: params[:name])
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
