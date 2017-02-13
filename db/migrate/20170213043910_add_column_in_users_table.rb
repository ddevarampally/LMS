class AddColumnInUsersTable < ActiveRecord::Migration[5.0]
  def up
  	if table_exists? :users
  		execute "ALTER TABLE users ADD COLUMN is_new_user BOOLEAN NOT NULL DEFAULT TRUE;"
  	else
  		puts 'users table is not exist in database'
	end
  end

  def down
  end
end
