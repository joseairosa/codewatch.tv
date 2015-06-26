class Api::V1::StreamController < Api::V1::ApiController

  include ChannelHelper
  include StreamerHelper

  def event
    @stream_name, @quality = params[:name].split('@')

    response = if @stream_name.start_with?('PS-')
                 process_private_session(PrivateSession.find(@stream_name))
               else
                 process_stream(User.where(username: @stream_name).first)
               end

    respond_to do |format|
      format.json { render response }
    end
  end

  def new_recording
    user = if params[:name].start_with?('PS-')
             PrivateSession.find(params[:name]).try(:user)
           else
             User.where(username: params[:name]).first
           end
    if user
      streamer_id = streamer_for_private_ip(URI.parse(params[:tcurl]).host)
      raise ArgumentError, "Could not find streamer for #{URI.parse(params[:tcurl]).host}" unless streamer_id
      Recording.create!(title: user.channel.title, streamer_id: streamer_id, user: user, name: params[:path].gsub('/tmp/', ''))
    end
    respond_to do |format|
      format.json { render json: {response: 'ok'}, status: 200 }
    end
  end

  private

  def process_stream(user)
    if user
      case params[:event]
        when 'play'
          user.channel.new_viewer

          StatisticService.instance.watching_stream(user.channel, @quality)
          ChannelService.instance.update_live_viewers(user.channel, user.channel.current_viewers, 1)

          {json: {response: 'ok'}, status: 200}
        when 'play_done'
          StatisticService.instance.finished_watching_stream(user.channel)
          ChannelService.instance.update_live_viewers(user.channel, user.channel.current_viewers, -1)

          {json: {response: 'ok'}, status: 200}
        when 'publish'
          valid_key = StreamService.instance.valid_stream_key?(user, params[:stream_key])
          if valid_key
            ChannelService.instance.go_online(user.channel)
            if params[:app] == 'stream' && user.can_record?
              {json: {response: 'ok'}, status: 302, location: "rtmp://127.0.0.1/record/#{params[:name]}?stream_key=#{params[:stream_key]}"}
            else
              {json: {response: 'ok'}, status: 200}
            end
          else
            {json: {response: 'fail'}, status: 401}
          end
        when 'publish_done'
          ChannelService.instance.go_offline(user.channel)
          {json: {response: 'ok'}, status: 200}
        else
          {json: {response: 'event_not_found'}, status: 404}
      end
    else
      {json: {response: 'user_not_found'}, status: 404}
    end
  end

  def process_private_session(private_session)
    user = private_session.try(:user)
    if user
      case params[:event]
        when 'play'
          StatisticService.instance.watching_private_session(private_session, @quality)
          PrivateSessionService.instance.update_live_viewers(private_session, private_session.current_viewers, 1)

          {json: {response: 'ok'}, status: 200}
        when 'play_done'
          StatisticService.instance.finished_watching_private_session(private_session)
          PrivateSessionService.instance.update_live_viewers(private_session, private_session.current_viewers, -1)

          {json: {response: 'ok'}, status: 200}
        when 'publish'

          valid_key = StreamService.instance.valid_stream_key?(private_session, params[:stream_key])
          if valid_key
            PrivateSessionService.instance.go_online(private_session)
            if params[:app] == 'stream' && user.can_record?
              {json: {response: 'ok'}, status: 302, location: "rtmp://127.0.0.1/record/#{params[:name]}?stream_key=#{params[:stream_key]}"}
            else
              {json: {response: 'ok'}, status: 200}
            end
          else
            {json: {response: 'fail'}, status: 401}
          end
        when 'publish_done'
          PrivateSessionService.instance.go_offline(private_session)
          {json: {response: 'ok'}, status: 200}
        else
          {json: {response: 'event_not_found'}, status: 404}
      end
    else
      {json: {response: 'user_not_found'}, status: 404}
    end
  end
end
