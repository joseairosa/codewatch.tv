class Chat
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :channel
  belongs_to :channel_external

  has_many :users_banned,     class_name: 'ChatUserBanned',     inverse_of: :chat
  has_many :users_moderator,  class_name: 'ChatUserModerator',  inverse_of: :chat

  def give_moderator(user)
    ChatUserModerator.create(chat: self, user: user) unless is_moderator?(user)
  end

  def remove_moderator(user)
    moderator_user = ChatUserModerator.where(chat_id: self.id, user_id: user.id).first
    moderator_user.delete if moderator_user
  end

  def ban(user)
    ChatUserBanned.create(chat: self, user: user) unless is_banned?(user)
  end

  def unban(user)
    banned_user = ChatUserBanned.where(chat_id: self.id, user_id: user.id).first
    banned_user.delete if banned_user
  end

  def is_moderator?(user)
    !ChatUserModerator.where(chat_id: self.id, user_id: user.id).count.zero?
  end

  def is_banned?(user)
    !ChatUserBanned.where(chat_id: self.id, user_id: user.id).count.zero?
  end
end
