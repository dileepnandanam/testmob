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
  scope 'api', module: 'api', as: :api do
    get '/actions/:action_id', to: 'actions#perform'
    post '/actions/:action_id', to: 'actions#perform'
    get '/auth/login', to: 'auth#login'
    post '/auth/login', to: 'auth#login'
    resources :interactive_tests do
      post :execute_touch, on: :collection
      post :execute_predefined_actions, on: :collection
      post :execute_text_command, on: :collection
      get :capture_screen_shot, on: :collection
      get :detect_marker, on: :collection
      get :connect_vision, on: :collection
      get :disconnect_vision, on: :collection
      get :restart_vision_server, on: :collection
    end
    get '/test/init', to: 'interactive_tests#init'
    get '/test/capture', to: 'interactive_tests#capture_screen_shot'
    get '/test/:action_id', to: 'interactive_tests#perform'
  end

  resources :tests do
    post :execute, on: :member
    get :configure, on: :collection
    post :submit, on: :collection
  end

  resources :interactive_tests, only: [:index]

  resources :api_docs

  resources :test_induviduals do
    get :advanced_mode, on: :collection
    get :basic_motion, on: :collection
    get :connections, on: :collection
    get :developer, on: :collection
    get :interpolated_mode, on: :collection
    get :others, on: :collection
    get :power_control, on: :collection
    get :rig_control, on: :collection
    get :dimenzio, on: :collection
    get :test_scenarios, on: :collection
  end

  resources :test_scenarios

  resources :app_configs do
    put :flush, on: :collection
    put :connect, on: :collection
    put :disconnect, on: :collection
    put :connect_vision, on: :collection
    put :disconnect_vision, on: :collection
  end

  require 'resque/server'
  mount Resque::Server, at: '/jobs'
end
