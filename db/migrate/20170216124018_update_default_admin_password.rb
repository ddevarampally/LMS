require "./lib/shared_modules"

class UpdateDefaultAdminPassword < ActiveRecord::Migration[5.0]
  include Generate_encrypt_password

  def up
  	if table_exists? :users
  		if column_exists?(:users, :password)
  			User.where(email_address: 'DDevarampally@capspayroll.com').update_all(password: generate_encrypted_password('lms@123').chomp)
  		else
  			puts 'password column is not exist in users table'
  		end
  	else
  		puts 'users table is not exist in database'
  	end
  end

  def down
  end
end