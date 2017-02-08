class CreateStatuses < ActiveRecord::Migration[5.0]
  def up
     if table_exists? :statuses
        puts 'statuses table is already exists in database'
     else
        create_table :statuses, primary_key: "status_id" do |t|
          
          t.string "status_name", :limit => 15, :null => false
        end    
        execute "ALTER TABLE statuses ADD CONSTRAINT unique_statuses_status_name UNIQUE(status_name);"    
        execute "ALTER TABLE statuses ALTER COLUMN status_id TYPE smallint;"
      end
  end

  def down
    
  end
end
