Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root to: "home#show"
  resources :users do 
    put :request_demo, on: :member
    put :accept_demo, on: :member
    put :demo_finished, on: :member
    put :pending_demo, on: :member
  end

  resources :tests do
    post :execute, on: :member
    get :configure, on: :collection
    post :submit, on: :collection
  end

  resources :test_induviduals do
    get :advanced_mode, on: :collection
    get :basic_motion, on: :collection
    get :connections, on: :collection
    get :developer, on: :collection
    get :interpolated_mode, on: :collection
    get :others, on: :collection
    get :power_control, on: :collection
    get :rig_control, on: :collection
  end

  resources :app_configs do
    put :connect, on: :collection
    put :disconnect, on: :collection
  end

  require 'resque/server'
  mount Resque::Server, at: '/jobs'
end
