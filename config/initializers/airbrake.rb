Rails.logger.info ENV['AIRBRAKE_CODEWATCH_KEY']
Rails.logger.info ENV['STRIPE_PUBLISHABLE_KEY']
Airbrake.configure do |config|
  config.ignore_only  = []
  config.api_key = ENV['AIRBRAKE_CODEWATCH_KEY']
end
