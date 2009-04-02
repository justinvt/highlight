class CreateHighlights < ActiveRecord::Migration
  def self.up
    create_table :highlights do |t|
      t.string :url, :tiny_url
      t.integer :x1, :y1, :x2, :y2
      t.text :src, :notes
      t.timestamps
    end
  end

  def self.down
    drop_table :highlights
  end
end
