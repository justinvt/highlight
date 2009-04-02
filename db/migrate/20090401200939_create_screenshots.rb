class CreateScreenshots < ActiveRecord::Migration

  def self.up
    create_table :screenshots do |t|
      t.integer :parent_id, :highlight_id, :size, :width, :height
      t.string :content_type, :filename, :thumbnail, :hash
    end
  end

  def self.down
    drop_table :screenshots
  end
end