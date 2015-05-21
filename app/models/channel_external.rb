class ChannelExternal
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActionView::Helpers::AssetUrlHelper

  before_update :sanitise_media
  after_create :create_chat

  belongs_to :user, class_name: 'UserExternal', inverse_of: :channel

  has_one :chat

  index name:       1
  index title:      1
  index status:     1
  index created_at: -1
  index updated_at: -1

  field :name,                  type: String
  field :title,                 type: String
  field :url,                   type: String
  field :status,                type: String
  field :one_line_description,  type: String
  field :media,                 type: String

  validates_uniqueness_of :name

  def thumbnail
    if user.media
      user.media['oembed']['thumbnail_url']
    else
      'no_thumbnail.png'
    end
  end

  def stream_html
    media.gsub('width="400" height="300"', '')
  end

  def online?
    true
  end

  def external?
    true
  end

  def does_not_have_media?
    media.empty?
  end

  private

  def sanitise_media
    self.media = HTMLEntities.new.decode self.media
  end

  def create_chat
    self.update(chat: Chat.create)
  end
end
