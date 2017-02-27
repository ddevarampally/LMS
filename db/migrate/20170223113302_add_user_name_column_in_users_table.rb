class AddUserNameColumnInUsersTable < ActiveRecord::Migration[5.0]
  def up
  	if table_exists? :users
  		if !column_exists?(:users, :user_name)
  			add_column :users, :user_name, :string, :limit => 20
  		else
  			puts 'user_name column is already exist in users table'
  		end
  	else
  		puts 'users table is not exist in database'
  	end
  end

  def down
  	if table_exists? :users
  		if column_exists?(:users, :user_name)
  			remove_column :users, :user_name
  		else
  			puts 'user_name column is not exist in users table'
  		end
  	else
  		puts 'users table is not exist in database'
  	end
  end
end
