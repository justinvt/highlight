class CreateHighlights < ActiveRecord::Migration
  def self.up
    create_table :highlights do |t|
      t.string :url
      t.integer :x1
      t.integer :y1
      t.integer :x2
      t.integer :y2
      t.string :tiny_url
      t.text :src
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :highlights
  end
end
