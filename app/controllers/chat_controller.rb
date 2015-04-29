class ChatController < ApplicationController
  def new_message
    raise 'User has to be logged' unless current_user
    ChatService.instance.new_message(current_user, params[:chat_id], params[:message])
    render json: nil, status: :ok
  end
end
