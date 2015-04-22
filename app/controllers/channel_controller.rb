require 'open-uri'

class ChannelController < ApplicationController

  helper_method :channel
  helper_method :channel_id
  helper_method :current_viewers

  QUALITIES = %w(180p 360p 720p)

  def show
    user = User.where(username: params[:username]).first
    redirect_to '/404' if user.nil? || params[:username].empty?
    @channel = user.channel
    @channel_id = params[:id]
  end

  private

  def current_viewers
    @current_viewers ||= begin
      nviewers = Channel::QUALITIES.inject(0) { |total_viewers, quality|
        viewers = URI.parse("http://streamer-01.codewatch.tv/subscriberss?app=watch&name=#{channel.user.username}@#{quality}").read.delete("\n").to_i
        if viewers <= 1
          total_viewers += 0
        else
          total_viewers += viewers-1
        end
        total_viewers
      }
      nviewers = 0 if nviewers < 0
      nviewers
    end
  end

  def channel_id
    channel.user.username
  end

  def channel
    @channel
  end
end
