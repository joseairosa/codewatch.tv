class Api::V1::RecordingController < Api::V1::ApiController
  def stats
    recording = Recording.find(params[:pageurl].split('/').last)
    if recording
      case params[:event]
        when 'play_done'
          recording.new_viewer
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
