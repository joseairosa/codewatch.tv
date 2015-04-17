class Chat
  include Mongoid::Document
  include Mongoid::Timestamps

  field :chat_id, type: String
  field :user_name, type: String
  field :content, type: String
end