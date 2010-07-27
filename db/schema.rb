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

ActiveRecord::Schema.define(:version => 20100727042755) do

  create_table "artist_allowed_pages", :force => true do |t|
    t.integer  "artist_id"
    t.integer  "page_id",    :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "artist_pages", :force => true do |t|
    t.integer  "artist_id",    :limit => 8
    t.integer  "page_id",      :limit => 8
    t.string   "access_token"
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

  create_table "events", :force => true do |t|
    t.integer  "object_id",      :limit => 8
    t.integer  "object_type_id"
    t.string   "object_name"
    t.integer  "event_id",       :limit => 8
    t.string   "event_location"
    t.string   "event_name"
    t.datetime "event_start"
    t.datetime "event_end"
    t.string   "rsvp_status"
    t.string   "city"
    t.string   "country"
    t.float    "logitude"
    t.float    "latitude"
    t.string   "state"
    t.string   "street"
    t.datetime "date_added"
    t.datetime "date_updated"
  end

  create_table "page_publish_pages", :force => true do |t|
    t.integer  "page_id",         :limit => 8
    t.integer  "publish_page_id", :limit => 8
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
