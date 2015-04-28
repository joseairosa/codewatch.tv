module ChannelHelper
  def is_channel_owner?(user=current_user)
    channel.user.id == user.id
  end

  def is_channel_moderator?(user=current_user)
    !!channel.chat.moderators.find { |moderator| moderator == user.id }
  end
end
