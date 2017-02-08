class InsertDataInTables < ActiveRecord::Migration[5.0]
  def up
  	if table_exists? :roles
      	execute "INSERT INTO roles(role_name) VALUES ('Admin');"
      	execute "INSERT INTO roles(role_name) VALUES ('Librarian');"
      	execute "INSERT INTO roles(role_name) VALUES ('User');"
    else
    	puts 'roles table is not exist in database'
    end

    if table_exists? :users
      	execute "INSERT INTO users(first_name, last_name, email_address, password, created_by, updated_by) VALUES ('Daniel', 'Devarampally', 'DDevarampally@capspayroll.com', 'lms@123', 'DDevarampally@capspayroll.com', 'DDevarampally@capspayroll.com');"
    else
    	puts 'users table is not exist in database'
    end

    if table_exists? :statuses
      	execute "INSERT INTO statuses(status_name) VALUES ('Borrowed');"
      	execute "INSERT INTO statuses(status_name) VALUES ('Returned');"
    else
    	puts 'statuses table is not exist in database'
    end

    if table_exists? :user_roles
      	execute "INSERT INTO user_roles(user_id, role_id) VALUES (1, 1);"
    else
    	puts 'user_roles table is not exist in database'
    end
  end

  def down
  end
end
