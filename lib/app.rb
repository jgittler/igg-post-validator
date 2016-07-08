require "pg"
require "active_record"
require "httparty"
require "csv"
require "action_mailer"
require "pry"

require_relative "../initializers/env.rb"

# Upload CSV
# Parse CSV
# Validate Share on FB
# Save validation result with relevant backer data
# Send email to backer on success

if production?
  ActiveRecord::Base.establish_connection(
    adapter: "postgresql",
    username: ENV.fetch("DB_USER"),
    database: ENV.fetch("PRODUCTION_DB_NAME")
  )
else
  ActiveRecord::Base.establish_connection(
    adapter: "postgresql",
    username: ENV.fetch("DB_USER"),
    database: ENV.fetch("TEST_DB_NAME")
  )
end

ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.default_options = { host: "felloeyewear.com" }
ActionMailer::Base.smtp_settings = {
  :address   => "smtp.gmail.com",
  :port      => 587,
  :domain    => "gmail.com",
  :authentication => :plain,
  :user_name      => "jason@felloeyewear.com",
  :password       => ENV.fetch("EMAIL_PASSWORD"),
  :enable_starttls_auto => true
}
ActionMailer::Base.view_paths = APP_ROOT
