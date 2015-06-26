class PrivateSessionService

  include Singleton

  def initialize

  end

  def add_participant(private_session, user)
    private_session.participants << user unless participant_is_allowed?(private_session, user)
  end

  def is_participant?(private_session, user)
    participant_is_allowed?(private_session, user)
  end

  def is_not_participant?(private_session, user)
    !participant_is_allowed?(private_session, user)
  end

  def participant_is_allowed?(private_session, user)
    private_session.participants.include?(user)
  end

  def update_live_viewers(private_session, value, adjustment=0)
    channel_viewers = value.to_i+(adjustment)
    channel_viewers = 0 if channel_viewers < 0
    private_session.update(current_viewers: channel_viewers)
  end

  def go_online(private_session)
    StatisticService.instance.private_session_online(private_session)
    private_session.elect_streamer
    private_session.update(is_online: 1)
    StatisticService.instance.online_private_sessions(PrivateSession.where(is_online: 1).count)
  end

  def go_offline(private_session)
    StatisticService.instance.private_session_offline(private_session)
    private_session.update(is_online: 0)
    StatisticService.instance.online_private_sessions(PrivateSession.where(is_online: 1).count)
  end
end
