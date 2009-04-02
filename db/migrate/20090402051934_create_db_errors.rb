class CreateDbErrors < ActiveRecord::Migration
  
  def self.up
    create_table :errors do |t|
      t.datetime :created_at
      t.integer :line
      t.text :explain
      t.datetime :updated_at
      t.string :url
      t.string :action
      t.integer :id
      t.integer :user_id
      t.string :type
      t.text :content
      t.string :user_name
      t.text :params
      t.string :file
      t.string :controller
      t.string :message, :referrer
      t.text :session_data
      end
    end

  def self.down
    drop_table :errors
  end
  
end
