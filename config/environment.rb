# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
  :user_name => 'apikey',
  :password => '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',
  :domain => 'yourdomain.com',
  :address => 'smtp.sendgrid.net',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}
