class PlusSubscriber
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Token

  include Concerns::Subscription

  token pattern: "PLUS-%s%s%s%s%s%s"

  belongs_to :user, inverse_of: :plus_subscriptions

  has_many :transactions, class_name: 'Transaction', inverse_of: :plus_subscription
end
