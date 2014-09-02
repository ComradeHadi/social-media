class HomeController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  layout "application"
  
  #################################################
  # method: index
  # parms: N/A
  # render: html
  # description: allows the user to sign in or signup
  # todo: fix homepage when user is login in
  #################################################
  def index
  	
  end
end
