Rails.application.routes.draw do

  #root page
  get "/" => "home#index", :as => "root"

  #user pages
  post "user/signup/" => "users#signup"
  post "user/email-exist" => "users#email_exist"
  post "user/username-exist" => "users#username_exist"
  post "user/login" => "users#login"
  get "user/logout" => "users#logout"
  get "user/edit" => "users#edit"
  post "user/edit" => "users#edit_post"
  get "search" => "users#search"

  #posts
  get "/posts/" => "posts#index"
  post "/posts/create/" => "posts#create"
  get "/:username/" => "posts#user_index"
  post "/posts/delete/:id/" => "posts#delete"
  post "/posts/feed/"  => "posts#feed"
  post "/posts/:username/feed/"  => "posts#user_feed"

  #create
  post "/comments/:post_id/create/" => "comments#create" 
  post "/comments/:post_id/feed/" => "comments#feed" 
  post "/comments/:post_id/delete/:comment_id" => "comments#delete" 

end
