class CreateVisitors < ActiveRecord::Migration
  def self.up
    create_table :artists do |t|
      t.integer   :fb_user_id, :limit=>8
      t.integer  :admin
      t.string    :access_token
      t.string    :auth_code
      t.timestamps
    end

      create_table :pages do |t|
      t.integer  :page_id, :limit => 8
      t.string    :access_token
      t.integer  :administrator_id , :limit => 8
      t.string    :name
      t.timestamps
    end



  end

  def self.down
    drop_table :artists
    drop_table :pages
  end
end
