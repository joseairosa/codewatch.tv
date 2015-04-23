require 'open-uri'

class ChannelService

  include Singleton

  def initialize

  end

  def number_viewers(channel)
    nviewers = Channel::QUALITIES.inject(0) { |total_viewers, quality|
      viewers = URI.parse("http://streamer-01.codewatch.tv/subscriberss?app=watch&name=#{channel.user.username}@#{quality}").read.delete("\n").to_i
      total_viewers += viewers
      total_viewers
    }
    nviewers = 0 if nviewers < 0
    nviewers
  end
end
