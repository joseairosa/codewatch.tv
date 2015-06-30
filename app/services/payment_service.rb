class PaymentService

  include Singleton

  def private_session_payment(current_user, private_session, payment_data)
    response = {}
    if private_session && PrivateSessionService.instance.is_not_participant?(private_session, current_user)


      customer = init_customer(current_user, payment_data['id'])

      charge = create_payment(current_user, customer, (private_session.price*100).to_i, "Signup to #{private_session.title}")

      if successfull_payment(charge)
        PrivateSessionService.instance.add_participant(private_session, current_user)
        response[:notice_type] = :notice
        response[:notice_message] = 'Payment successfull. Thank you!'
      else
        response[:notice_type] = :error
        response[:notice_message] = 'Internal error. Payment not taken!'
      end

    else
      response[:notice_type] = :error
      response[:notice_message] = 'Could not find session. Payment not taken!'
    end
    response
  end

  def plus_payment(current_user, payment_data)
    response = {}

    customer = init_customer(current_user, payment_data['id'])

    subscription = create_subscription(current_user, customer, 'codewatch-plus')

    if successfull_subscription(subscription)
      PrivateSessionService.instance.add_participant(private_session, current_user)

      response[:notice_type] = :notice
      response[:notice_message] = 'Payment successfull. Thank you!'
    else
      response[:notice_type] = :error
      response[:notice_message] = 'Internal error. Payment not taken!'
    end

    response
  end

  def init_customer(current_user, payment_id=nil)
    if current_user.stripe_customer_id
      customer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
      if payment_id
        customer.source = payment_id
        customer.save
      end
    else
      options_hash = {email: current_user.email}
      options_hash.merge!({card: payment_id}) if payment_id
      customer = Stripe::Customer.create(options_hash)
      current_user.update(stripe_customer_id: customer.id)
    end
    customer
  end

  def create_payment(current_user, customer, amount, description, currency='usd')
    charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => amount,
        :description => description,
        :currency    => currency
    )
    Transaction.create(user: current_user, source: charge.to_hash.to_json)
    charge
  end

  def create_subscription(current_user, customer, subscription_id)
    subscription = customer.subscriptions.create(plan: subscription_id)
    Transaction.create(user: current_user, source: subscription.to_hash.to_json)
    subscription
  end

  def successfull_payment(charge)
    charge.status == 'succeeded' && charge.paid
  end

  def successfull_subscription(subscription)
    subscription.status == 'active'
  end
end
