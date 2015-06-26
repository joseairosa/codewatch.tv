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
      viewers = URI.parse("http://#{channel.user.streamer_id}.codewatch.tv/subscribers?app=watch&name=#{channel.user.username}@#{quality}").read.delete("\n").to_i
      total_viewers += viewers
      total_viewers
    }
    nviewers = 0 if nviewers < 0
    nviewers
  end

  def update_live_viewers(channel, value, adjustment=0)
    channel_viewers = value.to_i+(adjustment)
    channel_viewers = 0 if channel_viewers < 0
    channel.update(current_viewers: channel_viewers)
    StatisticService.instance.live_online_users(channel, channel_viewers)
  end

  def update_recording_viewers(recording, value, adjustment=0)
    recording_viewers = value.to_i+(adjustment)
    recording_viewers = 0 if recording_viewers < 0
    recording.update(current_viewers: recording_viewers)
    StatisticService.instance.recording_online_users(recording, recording_viewers)
  end

  def subscribe(channel, user)
    channel.subscribe(user)
  end

  def unsubscribe(channel, user)
    channel.unsubscribe(user)
  end

  def like(channel, user)
    if channel && user
      found_like = ChannelLike.where(channel: channel, user: user).first
      unless found_like
        ChannelLike.create(channel: channel, user: user)
        channel.update(total_likes: channel.total_likes+1)
      end
    end
  end

  def unlike(channel, user)
    if channel && user
      found_like = ChannelLike.where(channel: channel, user: user).first
      if found_like
        found_like.delete
        channel.update(total_likes: channel.total_likes-1)
      end
    end
  end

  def go_online(channel)
    StatisticService.instance.stream_online(channel)
    channel.elect_streamer
    channel.update(is_online: 1)
    StatisticService.instance.online_streams(Channel.where(is_online: 1).count)
  end

  def go_offline(channel)
    StatisticService.instance.stream_offline(channel)
    channel.update(is_online: 0)
    StatisticService.instance.online_streams(Channel.where(is_online: 1).count)
  end
end
