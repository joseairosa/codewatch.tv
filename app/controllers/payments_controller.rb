class PaymentsController < ApplicationController
  before_action :authenticate_user!

  attr_reader :private_session

  helper_method :private_session

  def new_private_session
    @private_session = PrivateSession.find(params['id'])
    if @private_session
      add_breadcrumb "Private Session ##{private_session.token}", private_session_path(params['id'])
    else
      redirect_to '/404'
    end
  end

  def create
    case params['payment']['type']
      when 'private_session'
        private_session = PrivateSession.find(params['payment']['object'])
        response = PaymentService.instance.private_session_payment(current_user, private_session, params['payment'])
        response[:redirect_to] = private_session_path(params['payment']['object'])
      else
        response = {
            notice_type: :error,
            notice_message: 'Internal error: Payment not taken!',
            redirect_to: private_session_path(params['payment']['object'])}
    end

    flash[response[:notice_type]] = response[:notice_message]
    redirect_to response[:redirect_to]
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to private_session_path(params['payment']['object'])
  end
end
