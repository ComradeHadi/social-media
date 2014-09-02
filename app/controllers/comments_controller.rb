class CommentsController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  include ApplicationHelper


  before_action :restricted_loggedin_redirect, except: [:feed] #in ApplicationHelper

  #################################################
  # method: create
  # parms: post_id,content
  # render: json
  # description: allows a logged in user to create a comment on a post
  # todo: only allow comments from friends or configure in settings
  #################################################
  def create
    reutrn_ar = {}
    post_id = params[:post_id]
    user_id = User.get_user_id(session[:username])
    comment = params[:content]

    if !post_id.blank? && !user_id.blank? && !comment.blank? && Comment.create_comment(post_id,user_id,comment)
      reutrn_ar[:message] = "Comment created"
      reutrn_ar[:error] = false
    else
      reutrn_ar[:message] = "Error create comment..."
      reutrn_ar[:error] = true
    end

    render :json => reutrn_ar
  end

  #################################################
  # method: feed
  # parms: post_id
  # render: html
  # description: get comments feed for a post
  #################################################
  def feed
    @post_id = params[:post_id]
    @user_id = User.get_user_id(session[:username])

    if !@post_id.blank?
      @comments = Comment.get_comments(@post_id)
    end
    render :layout => false
  end

  #################################################
  # method: delete
  # parms: comment_id
  # render: json
  # description: allows user to delete his/her comment
  #################################################
  def delete
    reutrn_ar = {}

    comment_id = params[:comment_id]

    user_id = User.get_user_id(session[:username])

    if !user_id.blank? && Comment.delete_comment(comment_id,user_id)
      reutrn_ar[:message] = "Comment created"
      reutrn_ar[:error] = false
    else
      reutrn_ar[:message] = "Error deleteing comment..."
      reutrn_ar[:error] = true
    end

    render :json => reutrn_ar
  end
end
