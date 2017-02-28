class BooksController < ApplicationController
  	before_action :authenticate_user

  def index
  	@books = Book.includes(:user,:status).all
  end

  def add

      is_saved = false

      @add_book = Book.new

      @add_book.book_name = params[:book_name]
      @add_book.description = params[:description]
      @add_book.author_name = params[:author_name]
      @add_book.edition = params[:edition]
      @add_book.publication_name  = params[:publication_name]
      @add_book.publication_year = params[:publication_year]

       
      if !session[:current_email_address].nil?
        @add_book.created_by =  session[:current_email_address]
        @add_book.updated_by = session[:current_email_address]
      end

      ActiveRecord::Base.transaction do
        if @add_book.save
          is_saved = true
        end
      end
      
      respond_to do |format|
        format.html { render "index" }
        format.json { render json:is_saved.to_json }
      end
  end

  def edit
  
  end

  def delete
    
  end

  def subscribe
    
  end

  def activity_logs
  	respond_to do |format|
	    format.html
	    format.json { render json: ActivityLogsDatatable.new(view_context) }
  	end
  end
end
