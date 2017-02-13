class HomeController < ApplicationController    
    before_action :authenticate_user, :except => [:login, :validate_login, :forgot_password]

  def index
  end

  def login        
      @user = User.new  	
  end

  def validate_login
    @user = User.find_by(email_address: params[:user][:email_address], password: params[:user][:password], is_active: true)
    if @user
      session[:current_user_id] = @user.user_id
      session[:current_email_address] = @user.email_address
      session[:current_password] = @user.password
      session[:current_is_new_user] = @user.is_new_user

      if @user.is_new_user
          redirect_to home_change_password_path    
      else
          redirect_to home_index_path
      end      
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
    if request.post?
      @current_password = params[:user][:current_password]
      @new_password = params[:user][:new_password]

      if session[:current_password] != @current_password     
        @user = User.new        

        flash.now[:notice] = "Current Password is wrong"       
        render "change_password"
      else    
          @user = User.find(session[:current_user_id])
          if @user.update(password: @new_password, is_new_user: false)
              session[:current_password] = @user.password
              session[:current_is_new_user] = @user.is_new_user

              redirect_to home_index_path
          else
            flash.now[:notice] = "Error Occured while updating New Password"       
            render "change_password"
          end
      end
    else
      @user = User.new
      render "change_password"
    end  	
  end

  def logout
    session[:current_user_id] = nil
    session[:current_email_address] = nil
    session[:current_password] = nil
    session[:current_is_new_user] = nil

    redirect_to home_login_path
  end

end
