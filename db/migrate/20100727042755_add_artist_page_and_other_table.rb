class AddArtistPageAndOtherTable < ActiveRecord::Migration
  def self.up
    create_table "artist_pages", :force => true do |t|
      t.integer   "artist_id" , :limit=>8
      t.integer   "page_id", :limit=>8
      t.string   "access_token"
      t.timestamps
    end

     create_table "page_publish_pages", :force => true do |t|
      t.integer   "page_id" , :limit=>8
      t.integer   "publish_page_id", :limit=>8
      t.timestamps
    end
  end

  def self.down
    drop_table "artist_pages"
    drop_table "page_publish_pages"
  end
end
