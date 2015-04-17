class Api::V1::VideoController < Api::V1::ApiController
  def stats
    user = User.where(username: params[:pageurl].split('/').last).first
    if user
      case params[:event]
        when 'play'
          user.channel.new_viewer
        when 'play_done'
          user.channel.viewer_left
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
