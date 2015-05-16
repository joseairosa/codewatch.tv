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
end
