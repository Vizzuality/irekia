class AddDescriptionToArea < ActiveRecord::Migration
  def self.up
    add_column :areas, :description, :text
  end

  def self.down
    remove_column :areas, :description
  end
end
