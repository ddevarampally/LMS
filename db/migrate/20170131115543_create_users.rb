class CreateUsers < ActiveRecord::Migration[5.0]
   def up
     if table_exists? :users
        puts 'users table is already exists in database'
     else
        create_table :users, primary_key: "user_id" do |t|
          
          t.string "first_name", :limit => 30
          t.string "last_name", :limit => 20
          t.string "email_address", :limit => 30, :null => false
          t.string "password", :limit => 20, :null => false
          t.string "mobile_number", :limit => 15
          t.boolean "is_active", :null => false, :default => true
          t.string "created_by", :limit => 30, :null => false
          t.datetime "created_date", :null => false, :default => DateTime.now
          t.string "updated_by", :limit => 30, :null => false
          t.datetime "updated_date", :null => false, :default => DateTime.now
        end    
        execute "ALTER TABLE users ADD CONSTRAINT unique_users_email_address UNIQUE(email_address);"         
      end
  end

  def down  
    
  end
end
