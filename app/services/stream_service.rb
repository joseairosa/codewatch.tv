class StreamService

  include Singleton

  def valid_stream_key?(object, stream_key)
    case object
      when PrivateSession
        PrivateSession.where(user: object.user, stream_key: stream_key).count == 1
      when User
        User.where(username: object.username, stream_key: stream_key).count == 1
    end
  end
end
