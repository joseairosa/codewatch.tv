class PrivateSession
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Token

  include Concerns::Streamer

  belongs_to :user, class_name: 'User', inverse_of: :private_sessions

  has_many :participants, class_name: 'User', inverse_of: :private_session_participant
  has_many :transactions, class_name: 'Transaction'

  index title: 1
  index is_online: 1
  index status: 1

  field :title,             type: String
  field :live_at,           type: Time
  field :status,            type: Symbol, default: :upcoming
  field :max_participants,  type: Integer, default: 0
  field :description,       type: String
  field :timezone,          type: String
  field :is_online,         type: Integer, default: 0
  field :stream_key,        type: String, default: SecureRandom.uuid
  field :price,             type: Numeric, default: 0.0
  field :current_viewers,   type: Integer,  default: 0
  field :streamer_id,       type: String

  validate :valid_live_at_date

  token pattern: "PS-%s%s%s%s%s%s"

  def online?
    is_online == 1
  end

  private

  def valid_live_at_date
    if live_at.to_date < (created_at || Date.current).to_date
      errors.add(:live_at, 'Go live date cannot be in the past.')
    end
  end
end
