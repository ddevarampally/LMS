class UserDetailsDataTable
	delegate :params, :link_to ,to: :@view

	def initialize(view)
    	@view = view
	end

	def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: User.where(is_active: true).count,
      iTotalDisplayRecords: details.total_entries,
      aaData: data
    }
	end

private
  
  def data

    user_ids = details.pluck('user_id')
    @roles ={}

    if user_ids.any? 
        @user_roles = UserRole.includes(:role).where(user_id: user_ids)

        @user_roles.each  do |user_role|
            
            if @roles.key? (user_role.user_id)
                @roles[user_role.user_id] = "#{@roles[user_role.user_id]} | #{user_role.role.role_name}"
            else
                 @roles[user_role.user_id] = user_role.role.role_name
            end
        end   
    end

    details.map do |user_detail|
      [
        user_detail.user_id, 
        format_user_name(user_detail,true),
        user_detail.email_address,
        user_detail.mobile_number,
        format_role(@roles,user_detail.user_id),
        format_action_row_id,
        format_user_name(user_detail,false),
        format_user_name(user_detail,false,false),
        format_role(@roles,user_detail.user_id,true,ADMIN_ROLE),
        format_role(@roles,user_detail.user_id,true,LIBRARIAN_ROLE),
        format_role(@roles,user_detail.user_id,true,USER_ROLE)
      ]
    end
  end

  def details
    @details ||= fetch_details
  end

  def fetch_details
    @details = User.where(is_active: true).order("#{sort_column_user} #{sort_direction_user}")
    @details = @details.page(page_user).per_page(per_page_user)
   
    if params[:sSearch].present?
      @details = @details.where("lower(last_name) like :search or lower(first_name) like :search or lower(email_address) like :search or (mobile_number) like :search", search: "%#{(params[:sSearch]).downcase}%")
    end
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