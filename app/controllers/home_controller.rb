class HomeController < ApplicationController    
    before_action :authenticate_user, :except => [:login, :validate_login, :forgot_password]

  def index
  end

  def login        
      @user = User.new  	
  end

  def validate_login
    @user = User.find_by(email_address: params[:user][:email_address], password: params[:user][:password])
    if @user
      session[:current_user_id] = @user.user_id
      redirect_to home_index_path
    else
      @user = User.new
      @user.email_address = params[:user][:email_address] 
                     
      flash.now[:notice] = 'Invalid User Name or Password'        
      render "login"
    end
  end

  def forgot_password

  end

  def change_password
  	
  end

  def logout
    session[:current_user_id] = nil
    redirect_to home_login_path
  end

end
