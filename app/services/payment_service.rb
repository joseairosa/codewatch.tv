class PaymentService

  include Singleton

  def private_session_payment(current_user, private_session, payment_data)
    response = {}
    if private_session && PrivateSessionService.instance.is_not_participant?(private_session, current_user)

      if current_user.stripe_customer_id
        customer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
        customer.source = payment_data['id']
        customer.save
      else
        customer = Stripe::Customer.create(
            :email => current_user.email,
            :card  => payment_data['id']
        )
        current_user.update(stripe_customer_id: customer.id)
      end
      charge = Stripe::Charge.create(
          :customer    => customer.id,
          :amount      => (private_session.price*100).to_i,
          :description => "Signup to #{private_session.title}",
          :currency    => 'usd'
      )

      Transaction.create(user: current_user, source: charge.to_hash.to_json)

      if charge.status == 'succeeded' && charge.paid
        PrivateSessionService.instance.add_participant(private_session, current_user)
      end

      response[:notice_type] = :error
      response[:notice_message] = 'Payment successfull. Thank you!'
    else
      response[:notice_type] = :error
      response[:notice_message] = 'Internal error: Payment not taken!'
    end
    response
  end

end
