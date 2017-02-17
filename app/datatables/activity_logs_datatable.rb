class ActivityLogsDatatable
  delegate :params, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Book.where(is_active: true).count,
      iTotalDisplayRecords: logs.total_entries,
      aaData: data
    }
  end

private

  def data
    logs.map do |log|
      [
        log.book_name,
        log.description,
        log.updated_date.strftime("%b %e, %Y")
      ]
    end
  end

  def logs
    @logs ||= fetch_logs
  end

  def fetch_logs
    logs = Book.where(is_active: true).order("#{sort_column} #{sort_direction}")
    logs = logs.page(page).per_page(per_page)
    if params[:sSearch].present?
      logs = logs.where("lower(book_name) like :search or lower(description) like :search", search: "%#{(params[:sSearch]).downcase}%")
    end
    logs
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[book_name description updated_date]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end