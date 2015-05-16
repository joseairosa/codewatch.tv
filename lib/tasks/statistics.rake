namespace :statistics do
  desc 'Get online users'
  task online_users: :environment do
    StatisticService.instance.live_online_users(nil, ChannelService.instance.total_live_viewers)
    StatisticService.instance.recording_online_users(nil, ChannelService.instance.total_recording_viewers)
  end

  desc 'Get online streams'
  task online_streams: :environment do
    StatisticService.instance.online_streams(Channel.where(is_online: 1).count)
  end
end

