Rails.application.config.middleware.use OmniAuth::Builder do
  provider :venmo, ENV['VENMO_CLIENT_ID'], ENV['VENMO_CLIENT_SECRET'], :scope => 'access_profile,access_friends'
end