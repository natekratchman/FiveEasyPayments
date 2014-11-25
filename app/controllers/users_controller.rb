class UsersController < ApplicationController

  skip_before_action :require_login, only: [:about]
  
  def home
    ### PRODUCTION
    # payment_info = User.call_lucas
    # current_user.parse_info(payment_info)

    ### TESTING
    payment_info = User.call_lucas
    @current_user = User.find_by(name: payment_info["name"]) || User.create(name: payment_info["name"])
    @current_user.parse_info(payment_info)
  end

  def about
  end

  def error
    redirect_to root_path
  end
end
