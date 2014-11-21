class UsersController < ApplicationController

  def show
    @current_user = current_user
    # User.find(session[:user_id])

    payment_info = JSON.parse(open("https://api.venmo.com/v1/payments?access_token=#{session[:token]}&limit=1000").read)

    @current_user.parse_info(payment_info)
  end
end
