class StatisticService
  include Singleton

  def live_online_users(channel, value)
    Statistic.create(name: :live_online_users, value: value, channel: channel)
  end

  def recording_online_users(recording, value)
    Statistic.create(name: :recording_online_users, value: value, recording: recording)
  end

  def online_streams(value)
    Statistic.create(name: :online_streams, value: value)
  end

  def watching_quality(channel, value)
    Statistic.create(name: :watching_quality, value: value, channel: channel)
  end
end
