class ChannelLike
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :channel, inverse_of: :likes
  belongs_to :user, inverse_of: :channel_likes
end

