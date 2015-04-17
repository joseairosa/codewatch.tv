chat_configuration = YAML.load_file("#{Rails.root}/config/chat_server.yml")[Rails.env]
CHAT_SERVER_HOST = chat_configuration['host']
$redis = Redis.new(:host => chat_configuration['host'], :port=> 6379)