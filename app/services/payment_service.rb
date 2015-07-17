class PaymentService

  include Singleton

  def private_session_payment(user, private_session, payment_data)
    response = {}

    if private_session && PrivateSessionService.instance.is_not_participant?(private_session, user)

      customer = init_customer(user, payment_data['id'])

      charge = create_payment(customer, (private_session.price*100).to_i, "Signup to #{private_session.title}")

      if successfull_payment(charge)
        PrivateSessionService.instance.add_participant(private_session, user)

        Transaction.create!(private_session: user, source: charge.to_hash.to_json)

        StatisticService.instance.new_private_session_payment(user, private_session, 'success')

        response[:notice_type] = :notice
        response[:notice_message] = 'Payment successfull. Thank you!'
      else
        StatisticService.instance.new_private_session_payment(user, private_session, 'error')

        response[:notice_type] = :error
        response[:notice_message] = 'Internal error. Payment not taken!'
      end

    else
      response[:notice_type] = :error
      response[:notice_message] = 'Could not find session. Payment not taken!'
    end
    response
  end

  def plus_payment(user, payment_data)
    response = {}

    customer = init_customer(user, payment_data['id'])

    subscription = create_subscription(customer, 'codewatch-plus')

    if successfull_subscription(subscription)

      user_subscription = UserService.instance.subscribe_to_plus(user)

      Transaction.create!(plus_subscription: user_subscription, source: subscription.to_hash.to_json)

      StatisticService.instance.new_plus_subscription(user, 'success')

      response[:notice_type] = :notice
      response[:notice_message] = 'Payment successfull. Thank you!'
    else
      StatisticService.instance.new_plus_subscription(user, 'error')

      response[:notice_type] = :error
      response[:notice_message] = 'Internal error. Payment not taken!'
    end

    response
  end

  def subscription_payment(user, channel, payment_data)
    response = {}

    customer = init_customer(user, payment_data['id'])

    plan =  init_plan(channel)

    subscription = create_subscription(customer, plan.id)

    if successfull_subscription(subscription)

      user_subscription = ChannelService.instance.subscribe(channel, user)

      Transaction.create!(channel_subscription: user_subscription, source: subscription.to_hash.to_json)

      StatisticService.instance.new_channel_subscription(user, channel, 'success')

      response[:notice_type] = :notice
      response[:notice_message] = 'Payment successfull. Thank you!'
    else
      StatisticService.instance.new_channel_subscription(user, channel, 'error')

      response[:notice_type] = :error
      response[:notice_message] = 'Internal error. Payment not taken!'
    end

    response
  end

  def cancel_subscription(user, subscription_id)
    customer = init_customer(user)
    customer.subscriptions.retrieve(subscription_id).delete
  end

  private

  def init_customer(user, payment_id=nil)
    if user.stripe_customer_id
      customer = Stripe::Customer.retrieve(user.stripe_customer_id)
      if payment_id
        customer.source = payment_id
        customer.save
      end
    else
      options_hash = {email: user.email}
      options_hash.merge!({card: payment_id}) if payment_id
      customer = Stripe::Customer.create(options_hash)
      user.update(stripe_customer_id: customer.id)
    end
    customer
  end

  def create_payment(customer, amount, description, currency='usd')
    Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => amount,
        :description => description,
        :currency    => currency
    )
  end

  def init_plan(channel)
    username = channel.user.username
    begin
      plan = Stripe::Plan.retrieve(channel_subscription_name(username))
    rescue Stripe::InvalidRequestError => e
      if e.http_status == 404
        plan = Stripe::Plan.create(
            :amount => (BUSINESS_MODEL['prices']['channel_subscription']*100).to_i,
            :interval => 'month',
            :name => "Subscription to #{username} channel",
            :currency => 'usd',
            :id => channel_subscription_name(username)
        )
      else
        raise e
      end
    end
    plan
  end

  def create_subscription(customer, plan_id)
    customer.subscriptions.create(plan: plan_id)
  end

  def successfull_payment(charge)
    charge.status == 'succeeded' && charge.paid
  end

  def successfull_subscription(subscription)
    subscription.status == 'active' || subscription.status == 'trialing'
  end

  def channel_subscription_name(username)
    "#{username}-channel-subscription"
  end

end
