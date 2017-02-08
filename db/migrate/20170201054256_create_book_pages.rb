class CreateBookPages < ActiveRecord::Migration[5.0]
  def up
     if table_exists? :book_pages
        puts 'book_pages table is already exists in database'
     else
        create_table :book_pages, primary_key: "book_page_id" do |t|
          
          t.integer "book_id"
          t.string "page_type", :limit => 15, :null => false
          t.binary "page_content", :null => false
        end    
    	  execute "ALTER TABLE book_pages ADD CONSTRAINT fk_book_pages_books_book_id FOREIGN KEY(book_id) REFERENCES books(book_id);"	        
      end
  end

  def down    
  
  end
end
