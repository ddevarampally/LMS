class CreateUserRoles < ActiveRecord::Migration[5.0]
  def up
     if table_exists? :user_roles
        puts 'user_roles table is already exists in database'
     else
        create_table :user_roles, primary_key: "user_role_id" do |t|
          
          t.integer "user_id"
          t.integer "role_id", :limit => 1
        end    
        execute "ALTER TABLE user_roles ADD CONSTRAINT fk_user_roles_users_user_id FOREIGN KEY(user_id) REFERENCES users(user_id);"  
        execute "ALTER TABLE user_roles ADD CONSTRAINT fk_user_roles_roles_role_id FOREIGN KEY(role_id) REFERENCES roles(role_id);"        
      end
  end

  def down        
    
  end
end
