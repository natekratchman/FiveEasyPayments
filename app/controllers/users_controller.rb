class UsersController < ApplicationController

  def show
    

    # Production
    # @current_user = current_user
    # payment_info = User.call_lucas

    # Development/Test

    payment_info = User.call_lucas
    @current_user = User.find_by(name: "Kana") || User.create(name: "Kana")

    @current_user.parse_info(payment_info)
  end
end
