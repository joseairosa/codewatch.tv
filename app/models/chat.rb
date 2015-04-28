class Chat
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :channel

  field :banned_users,  type: Array, default: []
  field :moderators,    type: Array, default: []

  def give_moderator(user)
    unless is_moderator?(user)
      self.moderators << user.id
      save
    end
  end

  def remove_moderator(user)
    removed = self.moderators.delete(user.id)
    save if removed
  end

  def ban(user)
    unless is_banned?(user)
      self.banned_users << user.id
      save
    end
  end

  def unban(user)
    removed = self.banned_users.delete(user.id)
    save if removed
  end

  def is_moderator?(user)
    self.moderators.find { |moderator_user_id| moderator_user_id == user.id }
  end

  def is_banned?(user)
    self.banned_users.find { |banned_user_id| banned_user_id == user.id }
  end
end
