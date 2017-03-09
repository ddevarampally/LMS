require "./lib/shared_modules"
require "./app/datatables/user_details_datatable"

class UsersController < ApplicationController
 	before_action :authenticate_user

  include Generate_encrypt_password
  include Convert_to_boolean

  def index
    @generic_info = GenericInfo.new
    @generic_info.current_email_address = session[:current_email_address]
    @generic_info.is_admin = session[:is_admin]
    @generic_info.is_librarian = session[:is_librarian]
    @generic_info.is_user = session[:is_user]

  	respond_to do |format|
      format.html
      format.json { render json: UserDetailsDataTable.new(view_context, @generic_info) }
    end
  end

  def delete
      error_message = ""
      id = params[:id].to_i

      borrowed_books = Book.includes(:status).where(is_active: true, user_id: id).where(statuses: { status_name: BOOK_BORROWED })

      if borrowed_books.any?
        error_message = "Can't delete, because user is borrowed book(s)"
      else
        ActiveRecord::Base.transaction  do 
          
          @user_roles = UserRole.where(user_id: id )

          if @user_roles.delete_all

            ActiveRecord::Base.transaction  do
              @user = User.find(id)

              if !session[:current_email_address].nil?
                @user.updated_by = session[:current_email_address]
              end

              if @user.update_attributes(is_active: false, updated_date: DateTime.now)
                 error_message = "Success"
               end 
            end
          end
        end
      end

      respond_to do |format|
        format.html { render "index" }
        format.json { render json: error_message.to_json }
      end

  end

  def add

      @user_info = GenericInfo.new
      @user_info.error_message = ""

      is_edit_user = to_boolean(params[:is_edit_user])
      # Current Details of User
      has_admin_role = to_boolean(params[:has_admin_role])
      has_librarian_role = to_boolean(params[:has_librarian_role])
      has_user_role = to_boolean(params[:has_user_role])
      edit_first_name = params[:first_name]
      edit_last_name = params[:last_name]
      edit_phone_number = params[:phone_number]
      edit_email_address = params[:email_address]
      updated_by_user = (session[:current_email_address].nil?) ? "" : session[:current_email_address]

      @user = User.find_by(email_address: edit_email_address)
      if @user
        if (!is_edit_user && @user.is_active) || (is_edit_user && @user.user_id != params[:user_id].to_i)
          @user_info.error_message = "Email Exist" 
        elsif (!is_edit_user && !@user.is_active)
          @user_info.user_id = @user.user_id
          @user_info.first_name = @user.first_name
          @user_info.last_name = @user.last_name
          @user_info.phone_number = @user.mobile_number
          @user_info.error_message = "Inactive Email Exist" 
        end
      end
      if @user_info.error_message == ""

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
             
              if has_admin_role
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
                  @user_info.error_message = "Success"
                  
                  # Send Welcome Email Notification to newly add User.
                  UserMailer.user_notification_email(@add_user, WELCOME_MAIL_SUBJECT).deliver_now
                end
              end
            end
          end        
        else
          id = params[:user_id].to_i         
          user_ids = []
          
          #  Existing details of User
          is_exist_admin_role = to_boolean(params[:is_exist_admin_role])
          is_exist_librarian_role = to_boolean(params[:is_exist_librarian_role])
          is_exist_user_role = to_boolean(params[:is_exist_user_role])

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
              @delete_user_roles = UserRole.where(user_id: id, role_id: user_ids).delete_all
           end
           
           if user_roles.any?
             @add_update_user_roles = UserRole.create!(user_roles)
           end

           ActiveRecord::Base.transaction do            
              @user = User.find(id)

              if @user.is_active
                if @user.update_attributes(first_name: edit_first_name, last_name: edit_last_name, mobile_number: edit_phone_number, email_address: edit_email_address, updated_by: updated_by_user, updated_date: DateTime.now)
                  @user_info.error_message = "Success"
                end 
              else
                if @user.update_attributes(first_name: edit_first_name, last_name: edit_last_name, mobile_number: edit_phone_number, is_active: true, is_new_user: true, user_name: nil, updated_by: updated_by_user, updated_date: DateTime.now)
                  @user_info.error_message = "Success"

                   # Send Welcome Email Notification to newly add User.
                  UserMailer.user_notification_email(@user, WELCOME_MAIL_SUBJECT).deliver_now
                end 
              end
           end
          end
        end
      end
      respond_to do |format|
        format.html { render "index" }
        format.json { render json: @user_info }
      end
  end

  private
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
