Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get 'service-worker' => 'rails/pwa#service_worker', as: :pwa_service_worker
  get 'manifest' => 'rails/pwa#manifest', as: :pwa_manifest

  # Define your application routes here
  # User
  post '/user/register' => 'user#register', as: :user_register
  post '/user/login' => 'user#login', as: :user_login
  get '/user/find/:id' => 'user#find_by_id', as: :user_find_by_id

  # Admin
  post '/admin/register' => 'admin#register', as: :admin_register
  post '/admin/login' => 'admin#login', as: :admin_login
  get '/admin/find/:id' => 'admin#find_by_id', as: :admin_find_by_id

  # Business
  post '/business/register' => 'business#register', as: :business_register
  post '/business/login' => 'business#login', as: :business_login
  get '/business/find/:id' => 'business#find_by_id', as: :business_find_by_id

  # Business
  post '/commodity/register' => 'commodity#register', as: :commodity_register

  # Defines the root path route ("/")
  # root "posts#index"
end
