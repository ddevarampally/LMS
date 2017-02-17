class BooksController < ApplicationController
  	before_action :authenticate_user

  def index
  end
  
  def activity_logs
  	respond_to do |format|
	    format.html
	    format.json { render json: ActivityLogsDatatable.new(view_context) }
  	end
  end
end
