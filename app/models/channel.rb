class Channel
  include Mongoid::Document
  include Mongoid::Timestamps
  include Concerns::Searchable

  QUALITIES = %w(180p 360p 720p)

  belongs_to :user
  belongs_to :category

  has_one :chat

  after_create :create_chat

  index title: 1
  index is_online: 1
  index one_line_description: 1

  field :title,                 type: String,   default: 'Untitled broadcast'
  field :description,           type: String
  field :total_viewers,         type: Integer,  default: 0
  field :current_viewers,       type: Integer,  default: 0
  field :likes,                 type: Integer,  default: 0
  field :is_online,             type: Integer,  default: 0
  field :subscribers,           type: Array,    default: []
  field :one_line_description,  type: String

  def new_viewer
    self.total_viewers = self.total_viewers+1
    save
  end

  def viewer_left
    self.current_viewers = self.current_viewers-1
    self.current_viewers = 0 if self.current_viewers < 0
    save
  end

  def go_online
    self.is_online = 1
    save
  end

  def go_offline
    self.is_online = 0
    save
  end

  def online?
    is_online == 1
  end

  def subscribe(user)
    unless already_subscribed?(user)
      self.subscribers << user.id
      save
    end
  end

  def unsubscribe(user)
    removed = self.subscribers.delete(user.id)
    save if removed
  end

  private

  def already_subscribed?(user)
    self.subscribers.find { |subscribed_user_id| subscribed_user_id == user.id }
  end

  def create_chat
    self.chat = Chat.create
    save
  end
end
