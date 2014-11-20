# Rails.application.config.before_initialize do
#     ::Venmo = VenmoAPI::Client.new do |config|
#       config.client_id = ENV['VENMO_CLIENT_ID'].to_i
#       config.secret = ENV['VENMO_CLIENT_SECRET']
#       config.scope = ['access_profile', 'access_friends']
#       config.response_type = 'code'
#     end
#   end