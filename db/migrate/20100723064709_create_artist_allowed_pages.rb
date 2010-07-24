class CreateArtistAllowedPages < ActiveRecord::Migration
  def self.up
    create_table :artist_allowed_pages do |t|
      t.integer   :artist_id
      t.integer  :page_id, :limit=>8
      t.timestamps
    end

  end

  def self.down
    drop_table :artist_allowed_pages

  end
end