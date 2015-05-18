namespace :process do
  desc 'Process category viewers'
  task category_viewers: :environment do
    Category.all.each do |category|
      Rails.logger.info "Processing #{category.name}..."
      nviewers = 0
      category.channels.each do |channel|
        if channel.online?
          channel_viewers = ChannelService.instance.channel_viewers(channel)
          Rails.logger.info "Adding #{channel_viewers} for channel #{channel.user.username}..."
          nviewers += channel_viewers
        end
      end
      if nviewers.to_i != category.viewers.to_i
        Rails.logger.info "Updating #{category.name} with #{nviewers}..."
        category.update(viewers: nviewers)
      end
    end
  end

  desc 'Update all channels current viewers'
  task update_channels_current_viewers: :environment do
    Channel.all.each do |channel|
      current_viewers = ChannelService.instance.channel_viewers(channel)
      Rails.logger.info "Updating #{channel.user.username} with #{current_viewers} current viewers..."
      ChannelService.instance.update_live_viewers(channel, current_viewers)
    end
  end

  desc 'Update specific channel current viewers'
  task :update_channel_current_viewers, [:channel_name] => :environment do |_, args|
    user = User.where(name: args.channel_name).first
    if user
      current_viewers = ChannelService.instance.channel_viewers(user.channel)
      Rails.logger.info "Updating #{user.username} with #{current_viewers} current viewers..."
      ChannelService.instance.update_live_viewers(user.channel, current_viewers)
    end
  end
end
