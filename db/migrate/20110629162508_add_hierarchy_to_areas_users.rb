class AddHierarchyToAreasUsers < ActiveRecord::Migration
  def self.up
    add_column :areas_users, :hierarchy, :integer
  end

  def self.down
    remove_column :areas_users, :hierarchy
  end
end
