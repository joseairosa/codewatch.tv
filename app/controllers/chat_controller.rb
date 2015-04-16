class ChatController < ApplicationController
  def new_message
    message  = {
        user_name: current_user.username,
        chat_id: params[:chat_id],
        content: params[:message] }


    $redis.publish 'chat_message', message.to_json
    render json: nil, status: :ok
  end
end