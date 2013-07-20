Slothrop::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  config.asset_host = Proc.new {|source| 
    if source.starts_with?('/images')
      "http://slothrops.ee"
    else
      "http://localhost:3000"
    end
    }
  # Do not compress assets
  config.assets.compress = false
  # config.after_initialize do
  #   Bullet.enable = true
  #   Bullet.alert = true
  #   Bullet.bullet_logger = true
  #   Bullet.console = true
  #   Bullet.growl = false
  #   Bullet.rails_logger = true
  #   Bullet.disable_browser_cache = true
  # end
  # Expands the lines which load the assets
  config.assets.debug = true
  
  config.action_dispatch.best_standards_support = :builtin
  config.active_support.deprecation = :notify
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :file
  # Net::SMTP.enable_tls( OpenSSL::SSL::VERIFY_NONE )
  ActionMailer::Base.smtp_settings = {
    :address => "localhost",
    :port => 1025,
    :domain => "slothrops.ee" }
  
end
