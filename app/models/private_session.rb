class PrivateSession
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user, class_name: 'User', inverse_of: :private_sessions

  has_many :participants, class_name: 'User', inverse_of: :private_session_participant

  field :title,             type: String
  field :live_at,           type: Time
  field :max_participants,  type: Integer, default: 0
end
