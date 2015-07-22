class Channel
  include Mongoid::Document
  include Mongoid::Timestamps
  include Concerns::Searchable
  include Concerns::Streamer
  include Mongoid::Token

  QUALITIES = %w(180p 360p 720p)

  belongs_to :user
  belongs_to :category

  has_one :chat

  has_many :statistics
  has_many :likes,        class_name: 'ChannelLike'
  has_many :subscribers,  class_name: 'ChannelSubscriber', inverse_of: :channel

  after_create :create_chat

  index title: 1
  index is_online: 1
  index one_line_description: 1
  index current_viewers: -1

  field :title,                 type: String,   default: 'Untitled broadcast'
  field :description,           type: String
  field :total_viewers,         type: Integer,  default: 0
  field :current_viewers,       type: Integer,  default: 0
  field :likes,                 type: Integer,  default: 0
  field :total_likes,           type: Integer,  default: 0
  field :total_subscribers,     type: Integer,  default: 0
  field :is_online,             type: Integer,  default: 0
  field :one_line_description,  type: String
  field :streamer_id,           type: String

  token pattern: "C-%s%s%s%s%s%s"

  def new_viewer
    self.total_viewers = self.total_viewers+1
    save
  end

  def viewer_left
    self.current_viewers = self.current_viewers-1
    self.current_viewers = 0 if self.current_viewers < 0
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

  def is_subscriber?(user)
    if user
      !ChannelSubscriber.where(channel_id: self.id, user_id: user.id).count.zero?
    else
      false
    end
  end

  def thumbnail
    "https://codewatch-tv.s3-eu-west-1.amazonaws.com/stream-thumbnails/#{user.username}.png"
  end

  def external?
    false
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
