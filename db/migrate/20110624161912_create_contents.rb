class CreateContents < ActiveRecord::Migration
  def self.up
    create_table :contents do |t|

      t.integer  :related_content_id
      t.string   :type
      t.string   :tags
      t.datetime :published_at
      t.boolean  :moderated, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :contents
  end
end
