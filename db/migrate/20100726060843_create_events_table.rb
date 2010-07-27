class CreateEventsTable < ActiveRecord::Migration
  def self.up

    create_table "events", :force => true do |t|
      t.integer   "object_id" , :limit=>8
      t.integer   "object_type_id"
      t.string   "object_name"
      t.integer   "event_id", :limit=>8
      t.string   "event_location"
      t.string "event_name"
      t.datetime "event_start"
      t.datetime "event_end"
      t.string "rsvp_status"
      t.string "city"
      t.string "country"
      t.float "logitude"
      t.float "latitude"
      t.string "state"
      t.string "street"
      t.datetime "date_added"
      t.datetime "date_updated"


    end
  end

  def self.down
    drop_table "events"
  end
end