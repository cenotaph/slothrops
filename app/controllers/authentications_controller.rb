class AuthenticationsController < ApplicationController  
  def index  
  end  
  
  def handle_unverified_request
    true
  end



  def create
    omniauth = request.env["omniauth.auth"]
    logger.warn('omniauth is ' + omniauth.to_yaml)
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      flash[:notice] = "Authentication successful."
      redirect_to '/'
    elsif omniauth['provider'] == 'twitter' && user = User.find_by_username(omniauth['user_info']['nickname'])
      logger.warn('got here')
      user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      sign_in_and_redirect(:user, user)
    else
      user = User.new
      user.apply_omniauth(omniauth)
      if user.save
        flash[:notice] = "Signed in successfully."
        sign_in_and_redirect(:user, user)
      else
        session[:omniauth] = omniauth.except('extra')
        redirect_to new_user_registration_url
      end
    end
  end
    
  def destroy  
  end  
end  