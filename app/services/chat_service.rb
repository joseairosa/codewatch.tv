require 'securerandom'

class ChatService

  include Singleton

  def initialize

  end

  def new_message(user, chat_id, message)
    message_id = SecureRandom.uuid
    payload  = {
      id: message_id,
      user_name: user.username,
      chat_id: chat_id,
      user_image: user.gravatar_url,
      content: message
    }
    $redis.rpush "#{chat_id}_message_ids", message_id
    $redis.hset "#{chat_id}_messages", message_id, payload.to_json
    $redis.publish 'new_message', payload.to_json
  end

  def remove_message(channel, message_id)
    chat_id = channel.user.username
    payload  = {
      id: message_id,
      chat_id: chat_id
    }
    $redis.lrem "#{chat_id}_message_ids", -1, message_id
    $redis.hdel "#{chat_id}_messages", message_id
    $redis.publish 'removed_message', payload.to_json
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
