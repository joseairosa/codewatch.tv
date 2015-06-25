# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Codewatch::Application.initialize!

ActionMailer::Base.smtp_settings = {
    :user_name => ENV['CODEWATCH_SENDGRID_USERNAME'],
    :password => ENV['CODEWATCH_SENDGRID_PASSWORD'],
    :domain => 'codewatch.tv',
    :address => 'smtp.sendgrid.net',
    :port => 587,
    :authentication => :plain,
    :enable_starttls_auto => true
}

# ActionMailer::Base.smtp_settings = {
#     :domain => 'codewatch.tv',
#     :address => '127.0.0.1',
#     :port => 1025,
#     :authentication => :plain,
#     :enable_starttls_auto => true
# }
