class UserExternal
  include Mongoid::Document
  include Mongoid::Timestamps

  has_one :channel, class_name: 'ChannelExternal', inverse_of: :user

  field :username,  type: String
  field :domain,    type: String
  field :media,     type: Hash
  field :selftext,  type: String

  index username: 1, domain: 1

  after_create :create_channel

  validates_uniqueness_of :username

  private

  def create_channel
    ChannelExternal.create(user: self)
  end
end
