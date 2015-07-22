class StreamerWorker
  include Mongoid::Document
  include Mongoid::Timestamps

  CACHE = {}

  index name: 1

  field :name,      type: String
  field :streamers, type: Array, default: []

  class << self
    def streamers
      CACHE['streamer-lb'] ||= self.find_or_create_by(name: 'streamer-lb').streamers
    end

    def streamers_name_list
      self.streamers.map { |s| s['name'] }
    end

    def find_streamer(streamer_id)
      self.streamers.find { |s| s['name'] == streamer_id }
    end

    def update_streamers
      streamers_servers = FOG.servers.select { |s|
        s.tags['Group'] == 'streamer' &&
            public_ip_address.present? &&
            private_ip_address.present? &&
            s.tags['Active'] == 'yes'
      }
      streamers = streamers_servers.map { |s|
        {
            'name' => s.tags['Name'],
            'public_ip' => s.public_ip_address,
            'private_ip' => s.private_ip_address,
            'type' => s.tags['Type']}
      }
      if CACHE['streamer-lb'] != streamers
        CACHE['streamer-lb'] = streamers
        self.find_or_create_by(name: 'streamer-lb').update_attributes(streamers: CACHE['streamer-lb'])
      end
    end
  end
end
