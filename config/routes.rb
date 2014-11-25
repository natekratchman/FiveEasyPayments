Rails.application.routes.draw do

  resources :users

  root 'users#home'

  get '/login' => 'sessions#login'
  get '/about' => 'users#about'
  
  ## PRODUCTION
  get '/auth/venmo/callback/' => 'sessions#create'
  ###

  ## TESTING
  get '/authenticate' => 'sessions#create'
  ###

  get '/logout' => 'sessions#destroy'

  get '/:error' => 'users#error'
  
end
