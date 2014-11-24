class UsersController < ApplicationController

  def show
    ### PRODUCTION
    payment_info = User.call_lucas
    current_user.parse_info(payment_info)

    ### TESTING
    payment_info = User.call_lucas
    @current_user = User.find_by(name: payment_info["name"]) || User.create(name: payment_info["name"])
    @current_user.parse_info(payment_info)
  end
end
