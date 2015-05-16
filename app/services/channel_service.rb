require 'open-uri'

class ChannelService

  include Singleton

  def initialize

  end

  def total_live_viewers
    Channel.collection.aggregate([
                                     {'$group' => {
                                         '_id' => 'number_live_streams',
                                         'current_viewers' => {'$sum' => '$current_viewers'}
                                     }}
                                 ]).first['current_viewers'].to_i
  end

  def total_recording_viewers
    Recording.collection.aggregate([
                                     {'$group' => {
                                         '_id' => 'number_recording_streams',
                                         'current_viewers' => {'$sum' => '$current_viewers'}
                                     }}
                                 ]).first['current_viewers'].to_i
  end

  def channel_viewers(channel)
    nviewers = Channel::QUALITIES.inject(0) { |total_viewers, quality|
      viewers = URI.parse("http://streamer-01.codewatch.tv/subscriberss?app=watch&name=#{channel.user.username}@#{quality}").read.delete("\n").to_i
      total_viewers += viewers
      total_viewers
    }
    nviewers = 0 if nviewers < 0
    nviewers
  end

  def update_live_viewers(channel, adjustment=0)
    channel_viewers = channel_viewers(channel)
    channel.update(current_viewers: channel_viewers.to_i+(adjustment))
    StatisticService.instance.live_online_users(channel, channel_viewers)
  end

  def update_recording_viewers(recording, value, adjustment=0)
    recording.update(current_viewers: value.to_i+(adjustment))
    StatisticService.instance.recording_online_users(recording, value)
  end

  def subscribe(channel, user)
    channel.subscribe(user)
  end

  def unsubscribe(channel, user)
    channel.unsubscribe(user)
  end
end
