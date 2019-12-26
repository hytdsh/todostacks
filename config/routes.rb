Rails.application.routes.draw do
  root 'pages#main'
  get '/help', to: 'pages#help'
  get '/about', to: 'pages#about'
  get '/contact', to: 'pages#contact'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  devise_scope :user do
    get 'sign_in', :to => 'devise/sessions#new', :as => :new_user_session
    get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end



  get 'taskstest', :to => 'application#taskstest'
end
