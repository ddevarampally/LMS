class UsersController < ApplicationController
 	before_action :authenticate_user

  def index
  		@userRoles = UserRole.includes(:user).where(users: {is_active: true})
  end
end
