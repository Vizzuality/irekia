class ChangeTagsToTextInContents < ActiveRecord::Migration
  def self.up
    change_column :contents, :tags, :text
  end

  def self.down
    change_column :contents, :tags, :string
  end
end
