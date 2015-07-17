class UserService

  include Singleton

  def initialize

  end

  def make_featured(user)
    user.update(featured: 1)
  end

  def remove_featured(user)
    user.update(featured: 0)
  end

  def change_account_type(user, account_type)
    user.account_type.update!(name: account_type)
  end

  def subscribe_to_plus(user)
    change_account_type(user, :plus)
    PlusSubscriber.create!(user: user)
  end

  def cancel_plus_subscription(user, subscription_id)
    found_subscription = PlusSubscriber.find(subscription_id)
    if user && found_subscription && user.id == found_subscription.user.id
      result = PaymentService.instance.cancel_subscription(user, found_subscription.internal_id)
      Transaction.create!(plus_subscription: found_subscription, source: result.to_hash.to_json)
      StatisticService.instance.canceled_plus_subscription(user)
      return true
    end
    false
  end

  def create_private_session(user, options={})
    PrivateSession.create({user: user}.merge(options))
  end
end
