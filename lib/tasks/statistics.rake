namespace :statistics do
  desc 'Get online users'
  task online_users: :environment do
    StatisticService.instance.live_online_users(nil, ChannelService.instance.number_live_streams)
    StatisticService.instance.recording_online_users(nil, ChannelService.instance.number_recording_streams)
  end

  desc 'Get online streams'
  task online_streams: :environment do
    StatisticService.instance.online_streams(Channel.where(is_online: 1).count)
  end
end

