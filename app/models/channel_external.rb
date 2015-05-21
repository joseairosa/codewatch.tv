class ChannelExternal
  include Mongoid::Document
  include Mongoid::Timestamps

  before_update :sanitise_media

  belongs_to :user, class_name: 'UserExternal', inverse_of: :channel

  index name:       1
  index title:      1
  index status:     1
  index created_at: -1
  index updated_at: -1

  field :name,      type: String
  field :title,     type: String
  field :url,       type: String
  field :status,    type: String
  field :media,     type: String

  validates_uniqueness_of :name

  private

  def sanitise_media
    self.media = HTMLEntities.new.decode self.media
  end
end
