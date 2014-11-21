class UsersController < ApplicationController

  def show
    # Production
    # @current_user = current_user
    # payment_info = JSON.parse(open("https://api.venmo.com/v1/payments?access_token=#{session[:token]}&limit=1000").read)

    # Development/Test
    payment_info = JSON.parse(IO.read("/Users/kanaabe/Development/flatiron/FiveEasyPayments/app/controllers/seedhash.rb"))
    @current_user = User.create(name: "Kana")

    @current_user.parse_info(payment_info)
  end
end
