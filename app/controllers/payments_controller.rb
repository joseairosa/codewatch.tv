class PaymentsController < ApplicationController
  before_action :authenticate_user!

  def create
    private_session = PrivateSession.find(params['payment']['object'])
    if private_session && PrivateSessionService.instance.is_not_participant?(private_session, current_user)

      unless current_user.stripe_customer_id
        customer = Stripe::Customer.create(
            :email => current_user.email,
            :card  => params['payment']['id']
        )
        current_user.update(stripe_customer_id: customer.id)
      end
      charge = Stripe::Charge.create(
          :customer    => current_user.stripe_customer_id,
          :source      => params['payment']['id'],
          :amount      => (private_session.price*100).to_i,
          :description => "Signup to #{private_session.title}",
          :currency    => 'usd'
      )

      Transaction.create(user: current_user, source: charge.to_hash.to_json)

      if charge.status == 'succeeded' && charge.paid
        PrivateSessionService.instance.add_participant(private_session, current_user)
      end

      flash[:notice] = 'Payment successfull. Thank you!'
    else
      flash[:error] = 'Internal error: Payment not processed'
    end
    redirect_to private_session_path(params['payment']['object'])

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to private_session_path(params['payment']['object'])
  end
end
