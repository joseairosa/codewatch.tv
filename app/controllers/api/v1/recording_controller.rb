class Api::V1::RecordingController < Api::V1::ApiController
  def event
    recording = Recording.find(File.basename(params[:pageurl]))
    if recording
      case params[:event]
        when 'play'
          StatisticService.instance.watching_recording(recording)
          ChannelService.instance.update_recording_viewers(recording, recording.current_viewers, 1)
        when 'play_done'
          recording.new_viewer
          StatisticService.instance.finished_watching_recording(recording)
          ChannelService.instance.update_recording_viewers(recording, recording.current_viewers, -1)
        else
          # do nothing
      end
      respond_to do |format|
        format.json { render json: {status:'ok'}, status: 200 }
      end
    else
      respond_to do |format|
        format.json { render json: {status:'not_found'}, status: 404 }
      end
    end
  end
end
