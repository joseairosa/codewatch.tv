class Api::V1::StreamController < Api::V1::ApiController

  include ChannelHelper

  def event
    username, quality = params[:name].split('@')
    user = User.where(username: username).first
    response = if user
      case params[:event]
        when 'play'
          user.channel.new_viewer

          if params[:app] == 'vod'
            recording = Recording.find(File.basename(params[:pageurl]))
            if recording
              number_viewers = recording.current_viewers+1
              ChannelService.instance.update_recording_viewers(recording, number_viewers)
            end
          elsif params[:app] == 'watch'
            StatisticService.instance.watching_quality(quality)
            ChannelService.instance.update_live_viewers(user.channel)
          end

          {json: {auth: 'ok'}, status: 200}
        when 'play_done'
          if params[:app] == 'vod'
            recording = Recording.find(File.basename(params[:pageurl]))
            if recording
              number_viewers = recording.current_viewers-1
              ChannelService.instance.update_recording_viewers(recording, number_viewers)
            end
          elsif params[:app] == 'watch'
            ChannelService.instance.update_live_viewers(user.channel)
          end

          {json: {auth: 'ok'}, status: 200}
        when 'publish'
          valid = User.valid_stream_key?(params[:name], params[:stream_key])
          if valid
            user = User.where(username: params[:name]).first
            user.channel.go_online
            if params[:app] == 'stream' && user.can_record?
              {json: {auth: 'ok'}, status: 302, location: "rtmp://127.0.0.1/record/#{params[:name]}?stream_key=#{params[:stream_key]}"}
            else
              {json: {auth: 'ok'}, status: 200}
            end
          else
            {json: {auth: 'fail'}, status: 401}
          end
        when 'publish_done'
          user.channel.go_offline
          {json: {auth: 'ok'}, status: 200}
        else
          {json: {status:'event_not_found'}, status: 404}
      end
    else
      {json: {status:'user_not_found'}, status: 404}
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
      format.json { render json: {status:'ok'}, status: 200 }
    end
  end
end
