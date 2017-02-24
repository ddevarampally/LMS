class UpdateDefaultAdminUserName < ActiveRecord::Migration[5.0]
  def up
  	if table_exists? :users
  		if column_exists?(:users, :user_name)
  			User.where(email_address: 'DDevarampally@capspayroll.com').update_all(user_name: "tester")
  		else
  			puts 'user_name column is not exist in users table'
  		end
  	else
  		puts 'users table is not exist in database'
  	end
  end

  def down
  	if table_exists? :users
  		if column_exists?(:users, :user_name)
  			User.where(email_address: 'DDevarampally@capspayroll.com').update_all(user_name: nil)
  		else
  			puts 'user_name column is not exist in users table'
  		end
  	else
  		puts 'users table is not exist in database'
  	end
  end
end
