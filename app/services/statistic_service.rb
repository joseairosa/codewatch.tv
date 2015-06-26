class StatisticService
  include Singleton

  def load_balancer(status, options)
    Analytics.track(
        user_id: 'codewatch',
        event: 'Load Balancer Response',
        properties: {
            status: status,
            ip: options[:ip] || 'null',
            app: options[:app],
            name: options[:name]
        })
  end

  def online_streams(value)
    Analytics.track(
        user_id: 'codewatch',
        event: 'Total Online Streams',
        properties: { value: value })
  end

  def online_private_sessions(value)
    Analytics.track(
        user_id: 'codewatch',
        event: 'Total Online Private Sessions',
        properties: { value: value })
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
        properties: { value: value })
  end

  def stream_online(channel)
    Analytics.track(
        user_id: channel.user.id.to_s,
        event: 'Stream Online',
        properties: { title: channel.title, streamer_id: channel.streamer_id })
  end

  def private_session_online(private_session)
    Analytics.track(
        user_id: private_session.user.id.to_s,
        event: 'Private Session Online',
        properties: { private_session_id: private_session.token, title: private_session.title, streamer_id: private_session.streamer_id })
  end

  def stream_offline(channel)
    Analytics.track(
        user_id: channel.user.id.to_s,
        event: 'Stream Offline',
        properties: { title: channel.title, streamer_id: channel.streamer_id })
  end

  def private_session_offline(private_session)
    Analytics.track(
        user_id: private_session.user.id.to_s,
        event: 'Private Session Offline',
        properties: { private_session_id: private_session.token, title: private_session.title, streamer_id: private_session.streamer_id })
  end

  def watching_stream(channel, quality)
    Analytics.track(
        user_id: channel.user.id.to_s,
        event: 'Started Watching Stream',
        properties: { channel_id: channel.user.username, quality: quality })
  end

  def finished_watching_stream(channel)
    Analytics.track(
        user_id: channel.user.id.to_s,
        event: 'Finished Watching Stream',
        properties: { channel_id: channel.user.username })
  end

  def watching_private_session(private_session, quality)
    Analytics.track(
        user_id: private_session.user.id.to_s,
        event: 'Started Watching Private Session',
        properties: { private_session_id: private_session.token, quality: quality })
  end

  def finished_watching_private_session(private_session)
    Analytics.track(
        user_id: private_session.user.id.to_s,
        event: 'Finished Watching Private Session',
        properties: { private_session_id: private_session.token })
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
