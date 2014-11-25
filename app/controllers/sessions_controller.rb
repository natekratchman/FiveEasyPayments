class SessionsController < ApplicationController
  skip_before_action :require_login, except: [:destroy]
  def login  
  end

  def create
    
    ### PRODUCTION
    # @venmo_response = request.env['omniauth.auth']

    # @venmo_uid = @venmo_response.uid
    # @venmo_display_name = @venmo_response.extra.raw_info.display_name
    
    # user = User.login_or_create(@venmo_response)

    # session[:user_id] = user.id
    # session[:token] = @venmo_response.credentials.token

    # redirect_to root_path
    

    ### TESTING
    session[:user_id] = User.first.id
    redirect_to root_path
  end

  def destroy
    reset_session
    flash.now[:notice]="You are now logged out, thank you for visiting!"
    render :login
  end

end