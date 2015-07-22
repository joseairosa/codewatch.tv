module StreamerHelper
  def private_ip_for_streamer(streamer_id)
    ip = StreamerWorker.find_streamer(streamer_id).fetch('private_ip', nil)
    raise StandardError, "Could not find matching Private IP for #{streamer_id}" if ip.nil?
    ip
  end

  def public_ip_for_streamer(streamer_id)
    ip = StreamerWorker.find_streamer(streamer_id).fetch('public_ip', nil)
    raise StandardError, "Could not find matching Public IP for #{streamer_id}" if ip.nil?
    ip
  end
end
