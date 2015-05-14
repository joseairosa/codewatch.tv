class ChatUserBanned
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :chat, class_name: 'Chat', inverse_of: :users_banned
  belongs_to :user, inverse_of: :chats_banned
end
