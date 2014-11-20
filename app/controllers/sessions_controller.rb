class SessionsController < ApplicationController

  def new  
  end

  def create
    @venmo_response = request.env['omniauth.auth']

    @venmo_uid = @venmo_response.uid
    @venmo_display_name = @venmo_response.extra.raw_info.display_name
    
    user = User.login_or_create(@venmo_response)

    session[:user_id] = user.id
    session[:token] = @venmo_response.credentials.token

    redirect_to root_path
  end

  private
  def login
    User.find() || User.create
  end

end