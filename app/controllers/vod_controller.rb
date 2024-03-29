class VodController < ApplicationController

  helper_method :recording
  helper_method :recordings

  def index
    user = User.where(username: params[:username]).first
    return redirect_to '/404' if user.nil? || params[:username].empty?
    @recordings = user.recordings.where(visible: 1).order_by(created_at: :desc)
  end

  def show
    @recording = Recording.find(params[:recording_id])
    return redirect_to '/404' if @recording.nil? || params[:recording_id].empty? || !@recording.is_visible?
    add_breadcrumb 'VoDs', list_vod_path(@recording.user.username)
  end

  private

  def channel_id
    channel.user.username
  end

  def recording
    @recording
  end

  def recordings
    @recordings
  end

  def channel
    @channel
  end

  def page_id
    super.merge({page_id: 'vod'})
  end
end
