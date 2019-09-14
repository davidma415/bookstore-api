# Load the Rails application.
require_relative 'application'

ENV['GITHUB_WEBHOOK_SECRET'] = 'webhook_secret'

# Initialize the Rails application.
Rails.application.initialize!
