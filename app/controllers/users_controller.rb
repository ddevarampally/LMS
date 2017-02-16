require "./lib/shared_modules"

class UsersController < ApplicationController
 	before_action :authenticate_user

  include Generate_encrypt_password

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

  def add
      has_admin_role = params[:has_admin_role]
      has_librarian_role = params[:has_librarian_role]
      has_user_role = params[:has_user_role]

      @add_user = User.new

      @add_user.first_name = params[:first_name]
      @add_user.last_name  = params[:last_name]
      @add_user.mobile_number = params[:phone_number]
      @add_user.email_address = params[:user_name]

      @add_user.password = generate_password()
       
      if !session[:current_email_address].nil?
        @add_user.created_by =  session[:current_email_address]
        @add_user.updated_by = session[:current_email_address]
      end
      
        ActiveRecord::Base.transaction do 
          if @add_user.save

            @roles = Role.all
            user_roles = []
           
            if has_admin_role
             role = 
             user_roles.push(add_user_roles(@add_user.user_id,@roles,ADMIN_ROLE))
            end

            if has_librarian_role
              user_roles.push(add_user_roles(@add_user.user_id,@roles,LIBRARIAN_ROLE))
            end

            if has_user_role
               user_roles.push(add_user_roles(@add_user.user_id,@roles,USER_ROLE))
            end 

            if user_roles.any? 

              ActiveRecord::Base.transaction do
                  
                  @user_role = UserRole.create!(user_roles)

                  respond_to do |format|
                    format.html { render "index" }
                    format.json { render json:@add_user.save!.to_json }
                  end
              end
            end
          end
        end
    end

  def add_user_roles(user_id, roles ,str_role)
      user_roles = []
      if roles.any?
        role = roles.where(role_name: str_role).select("role_id").first
        roles_types = {user_id: user_id, role_id: role[:role_id]}
        user_roles.push(roles_types)
      end
    return user_roles

  end

end
