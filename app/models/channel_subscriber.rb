class ChannelSubscriber
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :channel, class_name: 'Channel', inverse_of: :subscribers
  belongs_to :user, inverse_of: :subscriptions
end
