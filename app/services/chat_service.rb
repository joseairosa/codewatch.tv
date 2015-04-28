class ChatService

  include Singleton

  def initialize

  end

  def toggle_moderator(channel, user)
    channel.chat.is_moderator?(user) ? remove_moderator(channel, user) : give_moderator(channel, user)
  end

  def give_moderator(channel, user)
    channel.chat.give_moderator(user)
  end

  def remove_moderator(channel, user)
    channel.chat.remove_moderator(user)
  end

  def ban(channel, user)
    channel.chat.ban(user)
  end

  def unban(channel, user)
    channel.chat.unban(user)
  end
end
