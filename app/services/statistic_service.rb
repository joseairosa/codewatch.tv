class StatisticService
  include Singleton

  def load_balancer(status, options)
    Analytics.track(
        anonymous_id: 'codewatch',
        event: 'Load Balancer Response',
        properties: {
            status: status,
            ip: options[:ip] || 'null',
            app: options[:app],
            name: options[:name]
        })
  end

  def live_online_users(channel, value)
    Analytics.track(
        user_id: channel.user.id.to_s,
        event: 'Online Viewers p/ Channel',
        properties: { value: value })
  end

  def recording_online_users(recording, value)
    Analytics.track(
        user_id: recording.user.id.to_s,
        event: 'Recording Viewers p/ Channel',
        properties: { title: channel.title })
  end

  def stream_online(channel)
    Analytics.track(
        user_id: channel.user.id.to_s,
        event: 'Stream Online',
        properties: { title: channel.title })
  end

  def stream_offline(channel)
    Analytics.track(
        user_id: channel.user.id.to_s,
        event: 'Stream Offline',
        properties: { title: channel.title })
  end

  def watching_stream(channel, quality)
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
    Analytics.track(
        user_id: user.id.to_s,
        event: 'New User',
        properties: { username: user.username })
  end

  def new_recording(recording)
    Analytics.track(
        user_id: recording.user.id.to_s,
        event: 'New Recording',
        properties: { name: recording.name })
  end
end
