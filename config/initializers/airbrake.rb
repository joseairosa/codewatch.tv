Airbrake.configure do |config|
  config.ignore_only  = []
  config.api_key = ENV['AIRBRAKE_CODEWATCH_KEY']
end
