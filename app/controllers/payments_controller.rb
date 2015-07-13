class PaymentsController < ApplicationController
  before_action :authenticate_user!

  attr_reader :private_session

  helper_method :private_session

  def new_private_session
    @private_session = PrivateSession.find(params['id'])
    if @private_session

      if @private_session.participants.count >= @private_session.max_participants.to_i
        flash[:error] = 'This session is already full'
        redirect_to private_session_path(params['payment']['object'])
      end

      if @private_session.price == 0
        PrivateSessionService.instance.add_participant(@private_session, current_user)
        redirect_to private_session_path(params['payment']['object'])
      else
        add_breadcrumb "Private Session ##{private_session.token}", private_session_path(params['id'])
      end
    else
      redirect_to '/404'
    end
  end

  def new_plus
    add_breadcrumb 'Upgrade to Plus!'
  end

  def plus_success
    add_breadcrumb 'Thank you for subscribing!'
  end

  def new_subscription
    add_breadcrumb 'Channel subscription'
  end

  def create
    case params['payment']['type']
      when 'private_session'
        response = process_private_session
      when 'plus'
        response = process_plus
      when 'channel_subscription'
        response = process_subscription
      else
        response = process_error
    end

    flash[response[:notice_type]] = response[:notice_message]
    redirect_to response[:redirect_to]
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to private_session_path(params['payment']['object'])
  end

  private

  def process_subscription
    channel = Channel.find(params['payment']['object'])
    if channel
      response = PaymentService.instance.subscription_payment(current_user, channel, params['payment'])
      response[:redirect_to] = user_channel_path(params['payment']['object'])
    else
      response = {
          notice_type: :error,
          notice_message: 'Could not find channel data',
          redirect_to: user_channel_path(params['payment']['object'])}
    end
    response
  end

  def process_plus
    response = PaymentService.instance.plus_payment(current_user, params['payment'])
    response[:redirect_to] = plus_success_payment_path
    response
  end

  def process_private_session
    private_session = PrivateSession.find(params['payment']['object'])
    if private_session
      response = PaymentService.instance.private_session_payment(current_user, private_session, params['payment'])
      response[:redirect_to] = private_session_path(params['payment']['object'])
    else
      response = {
          notice_type: :error,
          notice_message: 'Could not find private session data',
          redirect_to: user_channel_path(params['payment']['object'])}
    end
    response
  end

  def process_error
    {
        notice_type: :error,
        notice_message: 'Internal error: Payment not taken!',
        redirect_to: root_path
    }
  end
end
