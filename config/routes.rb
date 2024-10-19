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
  delete '/user/delete/:id' => 'user#delete_by_id', as: :user_delete_by_id

  # Admin
  post '/admin/register' => 'admin#register', as: :admin_register
  post '/admin/login' => 'admin#login', as: :admin_login
  get '/admin/find/:id' => 'admin#find_by_id', as: :admin_find_by_id
  delete '/admin/delete/:id' => 'admin#delete_by_id', as: :admin_delete_by_id

  # Business
  post '/business/register' => 'business#register', as: :business_register
  post '/business/login' => 'business#login', as: :business_login
  get '/business/find/:id' => 'business#find_by_id', as: :business_find_by_id
  delete '/business/delete/:id' => 'business#delete_by_id', as: :business_delete_by_id

  # Commodity
  post '/commodity/register' => 'commodity#register', as: :commodity_register
  get '/commodity/find/:id' => 'commodity#find_by_id', as: :commodity_find_by_id
  delete '/commodity/delete/:id' => 'commodity#delete_by_id', as: :commodity_delete_by_id

  # Post
  post '/post/post' => 'post#post', as: :post_post
  get '/post/find/:id' => 'post#find_by_id', as: :post_find_by_id
  delete '/post/delete/:id' => 'post#delete_by_id', as: :post_delete_by_id

  # Comment
  post '/comment/post' => 'comment#post', as: :comment_post
  get '/comment/find/:id' => 'comment#find_by_id', as: :comment_find_by_id
  delete '/comment/delete/:id' => 'comment#delete_by_id', as: :comment_delete_by_id

  # Announcement
  post '/announcement/post' => 'announcement#post', as: :announcement_post
  get '/announcement/find/:id' => 'announcement#find_by_id', as: :announcement_find_by_id
  delete '/announcement/delete/:id' => 'announcement#delete_by_id', as: :announcement_delete_by_id

  # Defines the root path route ("/")
  # root "posts#index"
end
