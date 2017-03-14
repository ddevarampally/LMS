require "./lib/shared_modules"
require "./app/datatables/book_details_datatable"

class BooksController < ApplicationController
  	before_action :authenticate_user

    include Convert_to_boolean

  def index
    @generic_info = GenericInfo.new
    @generic_info.is_admin = session[:is_admin]
    @generic_info.is_librarian = session[:is_librarian]
    @generic_info.is_user = session[:is_user]  

  	respond_to do |format|
      format.html
      format.json { render json: BookDetailsDataTable.new(view_context, @generic_info) }
    end
  end

  def add

      is_saved = false
      is_new_book = to_boolean(params[:is_new_book])

      name_of_book = params[:book_name]
      book_description = params[:description]
      book_author = params[:author_name]
      book_edition = params[:edition]
      book_publication_name  = params[:publication_name]
      book_publication_year = params[:publication_year]
      updated_by_user = (session[:current_email_address].nil?) ? "" : session[:current_email_address]

      if is_new_book

        @add_book = Book.new

        @add_book.book_name = name_of_book
        @add_book.description = book_description
        @add_book.author_name = book_author
        @add_book.edition = book_edition
        @add_book.publication_name  = book_publication_name
        @add_book.publication_year = book_publication_year
         
        if !session[:current_email_address].nil?
          @add_book.created_by =  session[:current_email_address]
          @add_book.updated_by = updated_by_user
        end

        ActiveRecord::Base.transaction do
          
          if @add_book.save

            @update_book_pages = BookPage.where(book_page_id: params[:book_page_ids])

            if @update_book_pages.any?
                
              if  @update_book_pages.update_all(book_id: @add_book.book_id)
                is_saved = true
              end 
            end
          end
        end

      else
        
        id = params[:book_id].to_i
        ActiveRecord::Base.transaction do
            
            @book = Book.find(id)

            if @book.update_attributes(book_name: name_of_book, description: book_description, author_name: book_author, edition: book_edition, publication_name: book_publication_name, publication_year:book_publication_year, updated_by: updated_by_user, updated_date: DateTime.now)
              is_saved = true
            end 
         end
      end
      respond_to do |format|
        format.html { render "index" }
        format.json { render json:is_saved.to_json }
      end
  end

  def delete
      
      is_book_deleted = false
      id = params[:id].to_i

      ActiveRecord::Base.transaction  do 
        
        @book = Book.find(id)

          if !session[:current_email_address].nil?
            @book.updated_by = session[:current_email_address]
          end

          if @book.update_attributes(is_active: false, updated_date: DateTime.now)
             
             ActiveRecord::Base.transaction do
               
              @delete_book_pages = BookPage.where(book_id: id)

              if @delete_book_pages.delete_all
                is_book_deleted =true
                
              end
             end
          end
      end

      respond_to do |format|
        format.html { render "index" }
        format.json { render json:is_book_deleted.to_json }
      end
  end

  def image_upload
    
      images = params[:uploaded_images]
      type_of_page = params[:page_type]
      existing_ids = params[:existing_ids].nil? ? [] : Array(params[:existing_ids])
      ids = []
      is_saved = false  
      is_update = false

      if images != nil && !images.empty?
        
        pages = []
        pages.push(add_book_pages(type_of_page,images))

        if !pages.empty?
                
          ActiveRecord::Base.transaction do
            if existing_ids.any?
              existing_ids.each do |id|
                ids.push(id.to_i)
              end
              if type_of_page == FRONT_PAGE || type_of_page == BACK_PAGE
                @book_page = BookPage.where(book_page_id: ids, book_id: nil, page_type: type_of_page)

                if !@book_page.empty?
                  @book_page.first.update_attributes(page_content: images[0])
                  is_update = true
                else
                  @book_pages = BookPage.create!(pages)
                end
              else
                @book_pages = BookPage.create!(pages)
              end              
            else
              @book_pages = BookPage.create!(pages)
            end
            if !is_update
              @book_pages.each do |added_page|               
                added_page.map { |x| 
                  ids.push(x.book_page_id)                  
                }               
              end
            end
            is_saved = true
         end
        end
      end    
      respond_to do |format|
        format.html { render "index" }
        format.json { render json: {result:is_saved, ids: ids} }
      end
  end

  def delete_uploaded_images
    
      ids = params[:ids]
      is_deleted = false

      ActiveRecord::Base.transaction do
        @book_pages = BookPage.where(book_page_id: ids, book_id: nil)

        is_deleted = @book_pages.delete_all ? true : false;

      end

      respond_to do |format|
        format.html { render "index" }
        format.json { render json: {result:is_deleted} }
      end
  end

  def subscribe

      is_saved = false
      book_id = params[:book_id].to_i

      @add_book_subscriber = BookSubscriber.new

      @add_book_subscriber.book_id = book_id
       
      if !session[:current_email_address].nil?
        @add_book_subscriber.created_by =  session[:current_email_address]
        @add_book_subscriber.updated_by =  session[:current_email_address]
      end

       if !session[:current_user_id].nil?
        @add_book_subscriber.user_id = session[:current_user_id]
      end
      
      ActiveRecord::Base.transaction do
        
        if @add_book_subscriber.save
            is_saved = true
        end
      end

      respond_to do |format|
        format.html { render "index" }
        format.json { render json: is_saved.to_json }
      end
  end

  def book_details
      book_id = params[:book_id]
      @book_info = Book.where(book_id: book_id).first

      @book_pages_info = BookPage.where(book_id: book_id)
  end

  def activity_logs
    	respond_to do |format|
  	    format.html
  	    format.json { render json: ActivityLogsDatatable.new(view_context) }
  	   end
  end

  private
  def add_book_pages(type_of_page,pages_content,id = nil)
      book_pages = []

      pages_content.each do |content|
        
        page = {book_id: id != nil ? id : nil, page_type: type_of_page, page_content: content}

        book_pages.push(page)
      end 

      return book_pages
  end

end
