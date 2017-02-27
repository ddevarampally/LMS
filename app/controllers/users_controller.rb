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

  def delete
      is_user_deleted = false
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
               is_user_deleted =true
             end 
          end
        end
      end

      respond_to do |format|
        format.html { render "index" }
        format.json { render json:is_user_deleted.to_json }
      end

  end

  def add

      is_user_saved_updated = false
      is_edit_user = params[:is_edit_user]

      # Current Details of User
      has_admin_role = params[:has_admin_role]
      has_librarian_role = params[:has_librarian_role]
      has_user_role = params[:has_user_role]
      edit_first_name = params[:first_name]
      edit_last_name = params[:last_name]
      edit_phone_number = params[:phone_number]
      edit_email_address = params[:email_address]
      updated_by_user = (session[:current_email_address].nil?) ? "" : session[:current_email_address]

      @roles = Role.all
      user_roles = []

      if !is_edit_user
       
        @add_user = User.new

        @add_user.first_name = edit_first_name
        @add_user.last_name  = edit_last_name
        @add_user.mobile_number = edit_phone_number
        @add_user.email_address = edit_email_address
        @add_user.updated_by = updated_by_user

        @add_user.password = generate_password()
         
        if !session[:current_email_address].nil?
          @add_user.created_by =  session[:current_email_address]
        end
        
        ActiveRecord::Base.transaction do 

          if @add_user.save
           
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
                is_user_saved_updated = true
                
                # Send Welcome Email Notification to newly add User.
                UserMailer.user_notification_email(@add_user, WELCOME_MAIL_SUBJECT).deliver_now
              end
            end
          end
        end
      
      else

        id = params[:user_id]
        user_ids = []
        
        #  Existing details of User
        is_exist_admin_role = params[:is_exist_admin_role]
        is_exist_librarian_role = params[:is_exist_librarian_role]
        is_exist_user_role = params[:is_exist_user_role]

        if is_exist_admin_role != has_admin_role
          
          if !is_exist_admin_role && has_admin_role
            user_roles.push(add_user_roles(id,@roles,ADMIN_ROLE))
          end

          if is_exist_admin_role && !has_admin_role
            user_ids.push(add_user_roles(id,@roles,ADMIN_ROLE,true))
          end
        
        end

        if is_exist_librarian_role != has_librarian_role
          
          if !is_exist_librarian_role && has_librarian_role
            user_roles.push(add_user_roles(id,@roles,LIBRARIAN_ROLE))
          end

          if is_exist_librarian_role && !has_librarian_role
             user_ids.push(add_user_roles(id,@roles,LIBRARIAN_ROLE,true))
          end

        end

        if is_exist_user_role != has_user_role
        
          if !is_exist_user_role && has_user_role
            user_roles.push(add_user_roles(id,@roles,USER_ROLE))
          end

          if is_exist_user_role && !has_user_role
             user_ids.push(add_user_roles(id,@roles,USER_ROLE,true))
          end
          
        end

        ActiveRecord::Base.transaction do
         
          # Add record if current user has admin role else remove record         
         if user_ids.any?
            @delete_user_roles = UserRole.where(role_id: user_ids).delete_all
         end
         
         if user_roles.any?

           @add_update_user_roles = UserRole.create!(user_roles)

         end

         ActiveRecord::Base.transaction do
            
            @user = User.find(id)

            if @user.update_attributes(first_name: edit_first_name,last_name: edit_last_name,mobile_number: edit_phone_number,email_address: edit_email_address,updated_by: updated_by_user)
              is_user_saved_updated = true
            end 
         end

        end

      end

      respond_to do |format|
        format.html { render "index" }
        format.json { render json:is_user_saved_updated.to_json }
      end
    end

  def add_user_roles(user_id, roles ,str_role,get_ids = false)
      user_roles = []
      if roles.any?
          role = roles.where(role_name: str_role).select("role_id").first
          if !get_ids
            roles_types = {user_id: user_id, role_id: role[:role_id]}
            user_roles.push(roles_types)
          else
            user_roles = role[:role_id]
          end
      end
    return user_roles
  end

end
