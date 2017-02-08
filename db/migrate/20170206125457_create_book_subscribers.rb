class CreateBookSubscribers < ActiveRecord::Migration[5.0]
  def up
     if table_exists? :book_subscribers
        puts 'book subscribers table is already exists in database'
     else
        create_table :book_subscribers, primary_key: "book_subscriber_id" do |t|
          
          t.integer "book_id"
          t.integer "user_id"          
          t.boolean "is_active", :null => false, :default => true
          t.string "created_by", :limit => 30, :null => false
          t.datetime "created_date", :null => false, :default => DateTime.now
          t.string "updated_by", :limit => 30, :null => false
          t.datetime "updated_date", :null => false, :default => DateTime.now
        end  	
      	execute "ALTER TABLE book_subscribers ADD CONSTRAINT fk_book_subscribers_books_book_id FOREIGN KEY(book_id) REFERENCES books(book_id);"
      	execute "ALTER TABLE book_subscribers ADD CONSTRAINT fk_book_subscribers_users_user_id FOREIGN KEY(user_id) REFERENCES users(user_id);"
      end
  end

  def down  
  
  end
end
