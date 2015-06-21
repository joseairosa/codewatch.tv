class Api::V1::StreamController < Api::V1::ApiController

  include ChannelHelper

  def event
    username, quality = params[:name].split('@')
    user = User.where(username: username).first
    response = if user
      case params[:event]
        when 'play'
          user.channel.new_viewer

          # StatisticService.instance.watching_quality(user.channel, quality)
          StatisticService.instance.watching_stream(user.channel, quality)
          # ChannelService.instance.update_live_viewers(user.channel, user.channel.current_viewers, 1)

          {json: {response: 'ok'}, status: 200}
        when 'play_done'
          StatisticService.instance.finished_watching_stream(user.channel)
          # ChannelService.instance.update_live_viewers(user.channel, user.channel.current_viewers, -1)

          {json: {response: 'ok'}, status: 200}
        when 'publish'
          valid = User.valid_stream_key?(params[:name], params[:stream_key])
          if valid
            user = User.where(username: params[:name]).first
            if params[:app] == 'stream' && user.can_record?
              {json: {response: 'ok'}, status: 302, location: "rtmp://127.0.0.1/record/#{params[:name]}?stream_key=#{params[:stream_key]}"}
            else
              ChannelService.instance.go_online(user.channel)
              {json: {response: 'ok'}, status: 200}
            end
          else
            {json: {response: 'fail'}, status: 401}
          end
        when 'publish_done'
          ChannelService.instance.go_offline(user.channel)
          {json: {response: 'ok'}, status: 200}
        else
          {json: {response:'event_not_found'}, status: 404}
      end
    else
      {json: {response:'user_not_found'}, status: 404}
    end
    respond_to do |format|
      format.json { render response }
    end
  end

  def new_recording
    user = User.where(username: params[:name]).first
    if user
      Recording.create!(title: user.channel.title, user: user, name: params[:path].gsub('/tmp/',''))
    end
    respond_to do |format|
      format.json { render json: {response:'ok'}, status: 200 }
    end
  end
end
