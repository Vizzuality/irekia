class AddWebsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :webs, :string, :length => 500
  end

  def self.down
    remove_column :users, :webs
  end
end
