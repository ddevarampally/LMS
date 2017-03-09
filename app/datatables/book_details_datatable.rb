class BookDetailsDataTable
	delegate :params, to: :@view

	def initialize(view, generic_info)
    	@view = view
      @book_status = nil
      @generic_info = generic_info    
      @book_pictures = {}  
      @total_records = 0
      @total_display_records = 0
	end

	def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      aaData: book_data,
      iTotalRecords: @total_records,
      iTotalDisplayRecords: @total_display_records      
    }
	end

private
  
  def book_data   
    book_details.map do |book_detail|
      [
        book_detail.book_id, 
        book_detail.book_name,
        format_book_picture(book_detail.book_id, @book_pictures),
        book_detail.description,
        format_book_status(book_detail),
        format_borrowed_user_name(book_detail),
        book_detail.borrowed_date.try(:strftime, '%B %d, %Y'),
        book_detail.due_date.try(:strftime, '%B %d, %Y'),
        format_book_action,
        book_detail.author_name,
        book_detail.edition,
        book_detail.publication_name,
        book_detail.publication_year        
      ]
    end
  end

  def book_details
    @details ||= fetch_book_details
  end

  def books_query
    @books = Book.includes(:user,:status).where(is_active: true)

    book_ids = @books.pluck('book_id')    
    if book_ids.any? 
        @pages = BookPage.where(book_id: book_ids, page_type: FRONT_PAGE)

        @pages.each  do |page|
            
            if !@book_pictures.key? (page.book_id)
                @book_pictures[page.book_id] = page.page_content
            end
        end   
    end
    @books
  end

  def fetch_book_details
    @details = books_query.order("#{sort_column_book} #{sort_direction_book}")
    @details = @details.page(page_book).per_page(per_page_book)
   
    @total_records = @details.count

    if params[:sSearch].present?
      @details = @details.where("lower(book_name) like :search or lower(description) like :search", search: "%#{(params[:sSearch]).downcase}%")
    end
    
    @total_display_records = @details.count

    @details
  end

  def page_book
    params[:iDisplayStart].to_i/per_page_book + 1
  end
 
  def per_page_book
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column_book
    columns = %w[book_name description]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction_book
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  def format_borrowed_user_name(book)
     user_name = (book.user_id != nil) ? "#{book.user.last_name.capitalize}, #{book.user.first_name.capitalize}" : ""
     return user_name
  end

  def format_book_status(book)
    @book_status = (book.status_id == nil) ? BOOK_AVAILABLE : book.status.status_name
    return @book_status
  end

  def format_book_picture(id,book_pictures)

    if (book_pictures.any?) && (book_pictures.key? (id))
      role = '<img src="'+ book_pictures[id] +'" style="width:50px;">'
    end
    return role
  end

  def format_book_action
    url = ""
    if (@generic_info.is_admin || @generic_info.is_librarian) && @book_status != BOOK_BORROWED
      url = "<a href='#' class='grid-link-btn editBook'>Edit</a> | <a href='#' class='grid-link-btn deleteBook'>Delete</a>"
    end 
    if !@generic_info.is_user.nil? && @generic_info.is_user && @book_status == BOOK_BORROWED
      url = url == "" ? "<a href='#' class='grid-link-btn subscribeBook'>Subscribe</a>" : "#{url} | <a href='#' class='grid-link-btn subscribeBook'>Subscribe</a>"  
    end
    return  url
  end

end