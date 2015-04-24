class VodController < ApplicationController

  def index
    user = User.where(username: params[:username]).first
    redirect_to '/404' if user.nil? || params[:username].empty?
    @recordings = user.recordings.where(visible: 1)
  end

  def show
    @recording = Recording.find(params[:recording_id])
    redirect_to '/404' if @recording.nil? || params[:recording_id].empty? || !@recording.is_visible?
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

  helper_method :recording
  helper_method :recordings
end
