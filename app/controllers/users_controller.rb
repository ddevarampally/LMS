class UsersController < ApplicationController
 	before_action :authenticate_user

  def index
  		@user_roles = UserRole.includes(:user,:role).where(users: {is_active: true})
  end
  
  def edit
  
  end

  def delete
  
  end

end
