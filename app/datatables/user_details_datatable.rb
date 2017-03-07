class UserDetailsDataTable
	delegate :params, :link_to ,to: :@view

  @@generic_info
  @@total_records
  @@total_display_records
  @@roles
  @@skip_user_ids

	def initialize(view, generic_info)
    	@view = view
      @@generic_info = generic_info
      @@roles = {}
      @@skip_user_ids = []
	end

	def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      aaData: data,
      iTotalRecords: @@total_records,
      iTotalDisplayRecords: @@total_display_records      
    }
	end

private
  
  def data 
    details.map do |user_detail|
      [
        user_detail.user_id, 
        format_user_name(user_detail,true),
        user_detail.email_address,
        user_detail.mobile_number,
        format_role(@@roles,user_detail.user_id),
        format_action_row_id,
        format_user_name(user_detail,false),
        format_user_name(user_detail,false,false),
        format_role(@@roles,user_detail.user_id,true,ADMIN_ROLE),
        format_role(@@roles,user_detail.user_id,true,LIBRARIAN_ROLE),
        format_role(@@roles,user_detail.user_id,true,USER_ROLE)
      ]
    end
  end

  def details
    @details ||= fetch_details
  end

  def users_query
    skip_users = [DEFAULT_ADMIN_EMAIL]
    if DEFAULT_ADMIN_EMAIL != @@generic_info.current_email_address
        skip_users.push(@@generic_info.current_email_address)
    end
    @users = User.where(is_active: true).where.not(email_address: skip_users)

    user_ids = @users.pluck('user_id')
    if user_ids.any?
      @user_roles = UserRole.includes(:role).where(user_id: user_ids)

      @user_roles.each  do |user_role|

        if @@roles.key? (user_role.user_id)
            @@roles[user_role.user_id] = "#{@@roles[user_role.user_id]} | #{user_role.role.role_name}"
        else
             @@roles[user_role.user_id] = user_role.role.role_name
        end

        if @@generic_info.is_librarian && !@@generic_info.is_admin
          has_admin_role = false
          has_librarian_role = false
          has_user_role = false

          if user_role.role.role_name == ADMIN_ROLE
            has_admin_role = true
          elsif user_role.role.role_name == LIBRARIAN_ROLE
            has_librarian_role = true
          elsif user_role.role.role_name == USER_ROLE
            has_user_role = true
          end

          if has_admin_role && !has_librarian_role && !has_user_role
            @@skip_user_ids.push(user_role.user_id)            
          end
        end
      end   
    end
    if !@@skip_user_ids.empty?
        @users = @users.where.not(user_id: @@skip_user_ids)
    end
    @users 
  end

  def fetch_details
    @details = users_query.order("#{sort_column_user} #{sort_direction_user}")
    @details = @details.page(page_user).per_page(per_page_user)
    
    @@total_records = @details.count

    if params[:sSearch].present?
      @details = @details.where("lower(last_name) like :search or lower(first_name) like :search or lower(email_address) like :search or (mobile_number) like :search", search: "%#{(params[:sSearch]).downcase}%")
    end

    @@total_display_records = @details.count

    @details
  end

  def page_user
    params[:iDisplayStart].to_i/per_page_user + 1
  end
 
  def per_page_user
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column_user
    columns = %w[last_name email_address mobile_number]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction_user
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  def format_user_name(user,is_full_name,is_first_name = true)

    user_name = is_full_name ? "#{user.last_name.capitalize}, #{user.first_name.capitalize}" : is_first_name ? "#{user.first_name.capitalize}" : "#{user.last_name.capitalize}"

    return user_name
  end

  def format_role(roles, id ,is_role_type = false, role_type = "")
    role = ""

    if (roles.any?) && (roles.key? (id))
      role = roles[id]
    end

    if is_role_type && (!role.empty?) 
      role = (role.include? (role_type)) ? "is_#{role_type}" : ""
    end

    return role
  end

  def format_action_row_id
    return "<a href='#' class='grid-link-btn editUser'>Edit</a> | <a href='#' class='grid-link-btn deleteUser'>Delete</a>"
  end
end