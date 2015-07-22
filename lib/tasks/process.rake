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
      Rails.logger.debug "Updating #{channel.user.username} with #{current_viewers} current viewers..."
      ChannelService.instance.update_live_viewers(channel, current_viewers)
    end
  end

  desc 'Update online channels current viewers'
  task update_online_channels_current_viewers: :environment do
    Channel.where(is_online: 1).each do |channel|
      current_viewers = ChannelService.instance.channel_viewers(channel)
      Rails.logger.debug "Updating #{channel.user.username} with #{current_viewers} current viewers..."
      ChannelService.instance.update_live_viewers(channel, current_viewers)
    end
  end

  desc 'Update offline channels current viewers'
  task update_offline_channels_current_viewers: :environment do
    Channel.where(is_online: 0).each do |channel|
      current_viewers = 0
      Rails.logger.debug "Updating #{channel.user.username} with #{current_viewers} current viewers..."
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

  desc 'Update reddit feeds'
  task :update_reddit_feeds, [:limit, :after, :before] => :environment do |_, args|
    options = {}
    if args['before'].present?
      options[:before] = "t3_#{args['before']}"
    # else
    #   last_updated = ChannelExternal.desc(:updated_at).limit(1).first
    #   if last_updated
    #     Rails.logger.info "Retrieving all reddit links before #{last_updated.name}..."
    #     options[:before] = last_updated.name
    #   end
    end
    options[:after] = "t3_#{args['after']}" if args['after'].present?
    options[:limit] = args['limit'] || 50
    options[:category] = :new

    Rails.logger.info "Calling reddit API with #{options}"

    links = REDDIT_CLIENT.links('WatchPeopleCode', options)

    Rails.logger.info "Updating #{links.count} external channels..."

    links.to_a.reverse.each do |link|
      user_external = UserExternal.where(username: link.attributes[:author]).first
      to_merge = {}
      to_merge[:media] = link.attributes[:media] if link.attributes[:media]
      to_merge[:selftext] = link.attributes[:selftext] if link.attributes[:selftext]
      if user_external
        Rails.logger.info "Updating external user #{link.attributes[:author]}..."
        user_external.update({domain: link.attributes[:domain]}.merge(to_merge))
      else
        Rails.logger.info "Creating external user #{link.attributes[:author]}..."
        user_external = UserExternal.create({username: link.attributes[:author], domain: link.attributes[:domain]}.merge(to_merge))
      end

      Rails.logger.info "Updating external channel #{link.attributes[:name]}..."
      user_external.channel.update(name: link.attributes[:name], media: link.attributes[:media_embed][:content], title: link.attributes[:title], url: link.attributes[:url], status: link.attributes[:link_flair_text])
    end

    Rails.logger.info 'Making sure all live streams are actually live...'

    ChannelExternal.where(status: 'Live').each do |channel|
      link = REDDIT_CLIENT.link(channel.name)
      channel.update(status: link.attributes[:link_flair_text]) unless link.attributes[:link_flair_text] == 'Live'
    end
  end
end
