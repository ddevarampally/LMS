class CreateRoles < ActiveRecord::Migration[5.0]
  def up
    if table_exists? :roles
      puts 'roles table is already exists in database'
    else
      create_table :roles, primary_key: "role_id" do |t|    	
        
        t.string "role_name", :limit => 15, :null => false        
      end        
      execute "ALTER TABLE roles ADD CONSTRAINT unique_roles_role_name UNIQUE(role_name);"        
      execute "ALTER TABLE roles ALTER COLUMN role_id TYPE smallint;"
    end
  end

  def down    	
  	
  end
end
