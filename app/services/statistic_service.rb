class StatisticService
  include Singleton

  def live_online_users(channel, value)
    Statistic.create(name: :live_online_users, value: value, channel: channel)
  end

  def recording_online_users(recording, value)
    Statistic.create(name: :recording_online_users, value: value, recording: recording)
  end

  # def online_streams(value)
  #   Statistic.create(name: :online_streams, value: value)
  #   Analytics.track(
  #       user_id: channel.user.id,
  #       event: 'Watching Quality',
  #       properties: { quality: value })
  # end

  def stream_online(channel)
    Analytics.track(
        user_id: channel.user.id.to_s,
        event: 'Stream Online',
        properties: { title: channel.title })
  end

  def stream_offline(channel)
    Analytics.track(
        user_id: channel.user.id.to_s,
        event: 'Stream Online',
        properties: { title: channel.title })
  end

  def watching_stream(channel, quality)
    StatisticService.instance.new_user(channel.user)
    Analytics.track(
        user_id: channel.user.id.to_s,
        event: 'Started Watching Stream',
        properties: { quality: quality })
  end

  def finished_watching_stream(channel)
    Analytics.track(
        user_id: channel.user.id.to_s,
        event: 'Finished Watching Stream')
  end

  def watching_recording(recording)
    Analytics.track(
        user_id: recording.user.id.to_s,
        event: 'Started Watching Recording',
        properties: { recording_id: recording.id })
  end

  def finished_watching_recording(recording)
    Analytics.track(
        user_id: recording.user.id.to_s,
        event: 'Finished Watching Recording',
        properties: { recording_id: recording.id })
  end

  def watching_quality(channel, value)
    # Statistic.create(name: :watching_quality, value: value, channel: channel)
    Analytics.track(
        user_id: channel.user.id.to_s,
        event: 'Watching Quality',
        properties: { quality: value })
  end

  def new_user(user)
    Analytics.identify(
        user_id: user.id.to_s,
        traits: {
            username: user.username,
            name: "#{user.first_name} #{user.last_name}",
            email: user.email,
            created_at: user.created_at
        })
  end

  def new_recording(recording)
    Analytics.track(
        user_id: recording.user.id.to_s,
        event: 'New Recording',
        properties: { name: recording.name })
  end
end
