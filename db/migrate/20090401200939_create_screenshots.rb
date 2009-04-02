class CreateScreenshots < ActiveRecord::Migration

  def self.up
    create_table :screenshots do |t|
      t.column :parent_id,  :integer
      t.column :content_type, :string
      t.column :filename, :string    
      t.column :thumbnail, :string 
      t.column :size, :integer
      t.column :width, :integer
      t.column :height, :integer
    end

  end

  def self.down
    drop_table :screenshots
    
    # only for db-based files
    # drop_table :db_files
  end
end
