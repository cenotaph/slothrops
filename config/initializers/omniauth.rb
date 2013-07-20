# if Rails.env.development?
#   Rails.application.config.middleware.use OmniAuth::Builder do
#     provider :facebook, 'PUT_YOUR_KEY_HERE', 'PUT YOUR SECRET HERE', {:client_options => {:ssl => {:ca_path => "/etc/ssl/certs"}}}
#     provider :twitter, 'PUT_YOUR_KEY_HERE', 'PUT YOUR SECRET HERE'
#   end
# elsif Rails.env.production?
#   Rails.application.config.middleware.use OmniAuth::Builder do
#     provider :facebook, 'PUT_YOUR_KEY_HERE', 'PUT YOUR SECRET HERE', {:client_options => {:ssl => {:ca_path => "/etc/ssl/certs"}}}
#     provider :twitter, 'PUT_YOUR_KEY_HERE', 'PUT YOUR SECRET HERE' 
#   end
# end