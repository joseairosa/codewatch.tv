module StreamerHelper
  def private_ip_for_streamer(streamer_id)
    begin
      STREAMERS_CONFIG[streamer_id]['private-ip']
    rescue NoMethodError => e
      nil
    end
  end

  def public_ip_for_streamer(streamer_id)
    begin
      STREAMERS_CONFIG[streamer_id]['public-ip']
    rescue NoMethodError => e
      nil
    end
  end

  def streamer_for_public_ip(public_ip)
    STREAMERS_CONFIG.find { |_, v| v['public-ip'] == public_ip }.try(:first)
  end

  def streamer_for_private_ip(private_ip)
    STREAMERS_CONFIG.find { |_, v| v['private-ip'] == private_ip }.try(:first)
  end
end
