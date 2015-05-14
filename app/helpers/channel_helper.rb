module ChannelHelper
  def current_viewers(channel)
    channel = @channel if @channel
    @current_viewers ||= begin
      nviewers = ChannelService.instance.number_viewers(channel)
      # That's you :)
      nviewers = 1 if nviewers == 0
      nviewers
    end
  end

  def is_channel_owner?(user=current_user)
    channel.user.id == user.id
  end

  def is_channel_moderator?(user=current_user)
    channel.chat.is_moderator?(user)
  end
end
