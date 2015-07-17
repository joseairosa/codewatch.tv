class Transaction
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Token

  token pattern: "TX-%s%s%s%s%s%s"

  belongs_to :private_session
  belongs_to :channel_subscription, class_name: 'ChannelSubscriber'
  belongs_to :plus_subscription, class_name: 'PlusSubscriber'

  field :source, type: String

  def data
    @data ||= JSON.parse(source)
  end

  def parent
    private_session || channel_subscription || plus_subscription
  end
end
