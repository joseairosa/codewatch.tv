class Api::V1::VideoController < Api::V1::ApiController
  def stats
    user = User.where(username: params[:name]).first
    if user
      case params[:event]
        when 'play'
          user.channel.new_viewer
        when 'play_done'
          user.channel.viewer_left
        else
          # do nothing
      end
    end
    respond_to do |format|
      format.json { render json: {auth:'ok'}, status: 200 }
    end
  end

  def new_recording
    user = User.where(username: params[:name]).first
    if user
      Recording.create!(title: user.channel.title, user: user, name: params[:path].gsub('/recordings/',''))
    end
    respond_to do |format|
      format.json { render json: {auth:'ok'}, status: 200 }
    end
  end
end
