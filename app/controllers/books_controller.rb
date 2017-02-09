class BooksController < ApplicationController
  	before_action :authenticate_user

  def index
  	@books = Book.includes(:user,:status).all
  end
  
  def activity_logs
  	@logs = Book.all
  end
end
