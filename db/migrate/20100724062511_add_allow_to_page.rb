class AddAllowToPage < ActiveRecord::Migration
  def self.up
    add_column :pages , :allow, :boolean, :default=>1
  end

  def self.down
     remove_column :pages , :allow

  end
end