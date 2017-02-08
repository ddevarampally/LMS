class BooksController < ApplicationController
  	before_action :authenticate_user

  def index
  end
  
  def activity_logs
  	@logs = Book.all
  end
end
