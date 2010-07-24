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

ActiveRecord::Schema.define(:version => 20100724062511) do

  create_table "artist_allowed_pages", :force => true do |t|
    t.integer  "artist_id"
    t.integer  "page_id",    :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "artists", :force => true do |t|
    t.integer  "fb_user_id",   :limit => 8
    t.integer  "admin"
    t.string   "access_token"
    t.string   "auth_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.integer  "page_id",          :limit => 8
    t.string   "access_token"
    t.integer  "administrator_id", :limit => 8
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "allow",                         :default => true
  end

end
