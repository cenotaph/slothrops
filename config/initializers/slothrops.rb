require 'amazon/ecs'
Amazon::Ecs.options = {
  :associate_tag => 'slothrops-20',
  :AWS_access_key_id => ENV['AWS_ACCESS_KEY'], 
  :AWS_secret_key => ENV['AWS_SECRET']
  }
  
  


Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET'], {:client_options => {:ssl => {:ca_path => "/etc/ssl/certs"}}}
  provider :twitter, ENV['TWITTER_CONSUMER_KEY'], ENV['TWITTER_CONSUMER_SECRET']
end

Twitter.configure do |config|
  config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
  config.oauth_token = ENV['TWITTER_OAUTH_KEY']
  config.oauth_token_secret = ENV['TWITTER_OAUTH_SECRET']
end

Slothrop::Application.configure do
  config.action_mailer.default_url_options = { :host => 'slothrops.ee' }
end


Net::SMTP.enable_tls( OpenSSL::SSL::VERIFY_NONE )
ActionMailer::Base.smtp_settings = {
    :tls => true,
    :address => "smtp.gmail.com",
    :port => 587,
    :domain => "slothrops.ee",
    :authentication => :plain,
    :user_name => ENV['ACTIONMAILER_LOGIN']
    :password => ENV['ACTIONMAILER_PASSWoRD']
  }
  

CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',       # required
    :aws_access_key_id      => ENV['AWS_ACCESS_KEY'],       # required
    :aws_secret_access_key  => ENV['AWS_SECRET'],       # required
    :region                 => 'eu-west-1'  # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = "slothrops-#{Rails.env.to_s}"                     # required
  # config.fog_host       = 'https://assets.example.com'            # optional, defaults to nil
  config.fog_public     = true                                   # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end  