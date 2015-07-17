class ChannelSubscriber
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Token

  include Concerns::Subscription

  token pattern: "CS-%s%s%s%s%s%s"

  belongs_to :channel, class_name: 'Channel', inverse_of: :subscribers
  belongs_to :user, inverse_of: :channel_subscriptions

  has_many :transactions, class_name: 'Transaction', inverse_of: :channel_subscription
end
