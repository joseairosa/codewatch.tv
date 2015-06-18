class PrivateSession
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user, class_name: 'User', inverse_of: :private_sessions

  has_many :participants, class_name: 'User', inverse_of: :private_session_participant

  field :title,             type: String
  field :live_at,           type: Time
  field :max_participants,  type: Integer, default: 0
  field :description,       type: String

  validate :valid_live_at_date

  private

  def valid_live_at_date
    if live_at.to_date < (created_at || Date.current).to_date
      errors.add(:live_at, 'Go live date cannot be in the past.')
    end
  end
end
