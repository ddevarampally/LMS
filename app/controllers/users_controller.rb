require "./lib/shared_modules"
require "./app/datatables/user_details_datatable"

class UsersController < ApplicationController
 	before_action :authenticate_user

  include Generate_encrypt_password

  def index
  	respond_to do |format|
      format.html
      format.json { render json: UserDetailsDataTable.new(view_context) }
    end
  end

  def edit
  
  end

  def delete
      is_deleted = false
      id = params[:id].to_i

      ActiveRecord::Base.transaction  do 
        
        @user_roles = UserRole.where(user_id: id )

        if @user_roles.delete_all
          ActiveRecord::Base.transaction  do
            @user = User.find(id)

            if !session[:current_email_address].nil?
              @user.updated_by = session[:current_email_address]
            end

            if @user.update_attributes(is_active: false)
               is_deleted =true
             end 
          end
        end
      end

      respond_to do |format|
        format.html { render "index" }
        format.json { render json:is_deleted.to_json }
      end

  end

  def add

      has_admin_role = params[:has_admin_role]
      has_librarian_role = params[:has_librarian_role]
      has_user_role = params[:has_user_role]

      @add_user = User.new

      @add_user.first_name = params[:first_name]
      @add_user.last_name  = params[:last_name]
      @add_user.mobile_number = params[:phone_number]
      @add_user.email_address = params[:email_address]

      @add_user.password = generate_password()
       
      if !session[:current_email_address].nil?
        @add_user.created_by =  session[:current_email_address]
        @add_user.updated_by = session[:current_email_address]
      end
      
      ActiveRecord::Base.transaction do 
        if @add_user.save

          @roles = Role.all
          user_roles = []
         
          if has_admin_role == "true"
           user_roles.push(add_user_roles(@add_user.user_id,@roles,ADMIN_ROLE))
          end

          if has_librarian_role == "true"
            user_roles.push(add_user_roles(@add_user.user_id,@roles,LIBRARIAN_ROLE))
          end

          if has_user_role == "true"
             user_roles.push(add_user_roles(@add_user.user_id,@roles,USER_ROLE))
          end 

          if user_roles.any? 

            ActiveRecord::Base.transaction do
              
              @user_role = UserRole.create!(user_roles)
               # Send Welcome Email Notification to newly add User.
                UserMailer.user_notification_email(@add_user, WELCOME_MAIL_SUBJECT).deliver_now
            end
          end
        end
      end
      respond_to do |format|
        format.html { render "index" }
        format.json { render json:@add_user.save!.to_json }
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
