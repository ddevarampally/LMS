class UpdateUserUserRole < ActiveRecord::Migration[5.0]
  def up
  	user_table_updation(true)
  end
  
  def down
  	user_table_updation(false)
  end

  def user_table_updation(is_up_or_down)
  	if table_exists? :users
  		if column_exists?(:users, :first_name)
  			change_column_null(:users, :first_name, is_up_or_down ? false : true )
  		end

  		if column_exists?(:users, :last_name)
  			change_column_null(:users, :last_name, is_up_or_down ? false : true)
  		end

  		if column_exists?(:users, :password)
  			change_column(:users, :password, :string, limit: is_up_or_down ? 60 : 20)
  		end

  		@user = User.find_by(email_address: 'DDevarampally@capspayroll.com')
  		   
			@user.is_new_user = !is_up_or_down 
	  		@user.created_by = 'DDevarampally@capspayroll.com'
	  		@user.updated_by = 'DDevarampally@capspayroll.com'
	  		 
	  		@user.save  
  	else
  		puts 'Users Table does not exists in the database'
  	end
  end
end
