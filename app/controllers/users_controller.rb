class UsersController < ApplicationController
 	before_action :authenticate_user

  def index
  		@user_roles = UserRole.includes(:user,:role).where(users: {is_active: true})

  		@roles = {}

  		@user_roles.each do |user|
  			if @roles.key? (user.user_role_id) 
  				@roles[user.user_role_id] = "#{@roles[user.user_role_id]} | #{user.role.role_name}"
  			else
  				 @roles[user.user_role_id] = user.role.role_name
  			end
  		end
  end
  
  def edit
  
  end

  def delete
  
  end

  def new

  end

end
