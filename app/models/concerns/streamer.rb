module Concerns
  module Streamer
    def elect_streamer
      online_streams = Channel.where(is_online: 1).to_a + PrivateSession.where(is_online: 1).to_a
      grouped_objs = online_streams.group_by{ |obj| obj.streamer_id }
      grouped_by_count = grouped_objs.inject({}) {|res, (k, v)| res[k] = v.count; res }
      grouped_by_count.merge!((STREAMERS_LIST - grouped_by_count.keys).inject({}) {|res, v| res[v] = 0; res })
      elected_streamer = Hash[grouped_by_count.sort_by{ |_,v| v }].keys.compact.first
      Rails.logger.info "#{token} assigned to streamer #{elected_streamer}"
      self.update(streamer_id: Hash[grouped_by_count.sort_by{ |_,v| v }].keys.first)
    end
  end
end
