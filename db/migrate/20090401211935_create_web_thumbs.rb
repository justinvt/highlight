class CreateWebThumbs < ActiveRecord::Migration
  def self.up
    create_table :web_thumbs do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :web_thumbs
  end
end
