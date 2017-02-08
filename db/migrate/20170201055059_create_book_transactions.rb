class CreateBookTransactions < ActiveRecord::Migration[5.0]
  def up
     if table_exists? :book_transactions
        puts 'book_transactions table is already exists in database'
     else
        create_table :book_transactions, primary_key: "book_transaction_id" do |t|

          t.integer "book_id"
          t.integer "user_id"
          t.integer "status_id", :limit => 1
          t.datetime "borrowed_date"
          t.datetime "due_date"
          t.datetime "return_date"      
          t.string "created_by", :limit => 30, :null => false
          t.datetime "created_date", :null => false, :default => DateTime.now
          t.string "updated_by", :limit => 30, :null => false
          t.datetime "updated_date", :null => false, :default => DateTime.now
        end    
      	execute "ALTER TABLE book_transactions ADD CONSTRAINT fk_book_transactions_books_book_id FOREIGN KEY(book_id) REFERENCES books(book_id);"
      	execute "ALTER TABLE book_transactions ADD CONSTRAINT fk_book_transactions_users_user_id FOREIGN KEY(user_id) REFERENCES users(user_id);"
      	execute "ALTER TABLE book_transactions ADD CONSTRAINT fk_book_transactions_statuses_status_id FOREIGN KEY(status_id) REFERENCES statuses(status_id);"
        execute "ALTER TABLE book_transactions ALTER COLUMN book_transaction_id TYPE bigint;"
      end
  end

  def down    
  
  end
end
