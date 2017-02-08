class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  protected
  def authenticate_user
  	if session[:current_user_id].nil?
  		redirect_to home_login_path
  	end
  end
end
