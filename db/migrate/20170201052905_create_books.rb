class CreateBooks < ActiveRecord::Migration[5.0]
  def up
     if table_exists? :books
        puts 'books table is already exists in database'
     else
        create_table :books, primary_key: "book_id" do |t|
          
          t.string "book_name", :limit => 50, :null => false
          t.string "author_name", :limit => 50
          t.string "edition", :limit => 10
          t.string "publication_name", :limit => 50
          t.string "publication_year", :limit => 4
          t.string "description", :limit => 500
          t.integer "user_id"
          t.integer "status_id", :limit => 1
          t.datetime "borrowed_date"
          t.datetime "due_date"
          t.datetime "return_date"
          t.boolean "is_active", :null => false, :default => true
          t.string "created_by", :limit => 30, :null => false
          t.datetime "created_date", :null => false, :default => DateTime.now
          t.string "updated_by", :limit => 30, :null => false
          t.datetime "updated_date", :null => false, :default => DateTime.now
        end  	
      	execute "ALTER TABLE books ADD CONSTRAINT fk_books_users_user_id FOREIGN KEY(user_id) REFERENCES users(user_id);"
      	execute "ALTER TABLE books ADD CONSTRAINT fk_books_statuses_status_id FOREIGN KEY(status_id) REFERENCES statuses(status_id);"  
      end
  end

  def down  
  
  end
end
