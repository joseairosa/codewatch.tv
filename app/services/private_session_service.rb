class PrivateSessionService

  include Singleton

  def initialize

  end

  def add_participant(private_session, user)
    private_session.participants << user unless participant_is_allowed?(private_session, user)
  end

  def participant_is_allowed?(private_session, user)
    private_session.participants.include?(user)
  end
end
