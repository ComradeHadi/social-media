 class PostsController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  include ApplicationHelper


  before_action :restricted_loggedin_redirect, except: [:user_index] #in ApplicationHelper

  #################################################
  # method: index
  # parms: N/A
  # render: html
  # description: allows the current user to check there posts
  #################################################
  def index
    username = session[:username]

    @posts = Post.get_all(username)

    render "index", :locals => {username: username}
  end

  #################################################
  # method: user_index
  # parms: username
  # render: html
  # description: allows the user to view other users pages
  #################################################
  def user_index 
    username = params[:username]
    
    @posts = Post.get_all(username)
    render "index", :locals => {username: username}
  end 

  #################################################
  # method: feed
  # parms: N/A
  # render: html
  # description: allows the user to view his/her feed
  #################################################
  def feed
    username = session[:username]
    posts = Post.get_all(username)
    render :partial => "feed", :locals => {posts: posts, username: username}
  end

  #################################################
  # method: user_feed
  # parms: username
  # render: html
  # description: allows the user to view other users feeds
  #################################################
  def user_feed
    username = params[:username]
    posts = Post.get_all(username)
    render :partial => "feed", :locals => {posts: posts, username: username}
  end

  #################################################
  # method: create
  # parms: content
  # render: json
  # description: allows the user to create a new post
  #################################################
  def create
    return_ar = {}

    #checks if they have something to commit
    if !params[:content].blank? && Post.create(session[:username],params[:content])
      return_ar[:error] = false
      return_ar[:message] = 'Post was successfully created.'
    else
      return_ar[:error] = true
      return_ar[:message] = 'Error have not content to create'
    end
    render :json => return_ar
  end

  #################################################
  # method: delete
  # parms: id
  # render: json
  # description: allows the user delete his/her posts
  # todo: delete comments too
  #################################################
  def delete
    return_ar = {}
    id = params[:id]

    if !id.blank? && Post.delete_post(id,session[:username])
      return_ar[:error] = false
      return_ar[:message] = "Delete post successfully"
    else
      return_ar[:error] = true
      return_ar[:message] = "Error Deleting post width id: #{id}"
    end

    render :json => return_ar
  end
end
