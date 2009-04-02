# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090402051934) do

  create_table "errors", :force => true do |t|
    t.datetime "created_at"
    t.integer  "line"
    t.text     "explain"
    t.datetime "updated_at"
    t.string   "url"
    t.string   "action"
    t.integer  "user_id"
    t.string   "type"
    t.text     "content"
    t.string   "user_name"
    t.text     "params"
    t.string   "file"
    t.string   "controller"
    t.string   "message"
    t.string   "referrer"
    t.text     "session_data"
  end

  create_table "highlights", :force => true do |t|
    t.string   "url"
    t.string   "tiny_url"
    t.integer  "x1"
    t.integer  "y1"
    t.integer  "x2"
    t.integer  "y2"
    t.text     "src"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "screenshots", :force => true do |t|
    t.integer "parent_id"
    t.integer "highlight_id"
    t.integer "size"
    t.integer "width"
    t.integer "height"
    t.string  "content_type"
    t.string  "filename"
    t.string  "thumbnail"
    t.string  "hash"
  end

  create_table "web_thumbs", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
