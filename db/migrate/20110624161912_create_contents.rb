class CreateContents < ActiveRecord::Migration
  def self.up
    create_table :contents do |t|

      t.integer  :related_content_id
      t.string   :type
      t.string   :tags
      t.datetime :published_at
      t.boolean  :moderated, :default => false
      t.boolean  :rejected, :default => false
      t.datetime :moderated_at
      t.float    :latitude
      t.float    :longitude

      t.integer :comments_count, :default => 0
      t.integer :answer_requests_count, :default => 0

      t.timestamps
    end

    add_index :contents, [:id, :type]
    add_index :contents, [:id, :type, :moderated]
    add_index :contents, [:id, :published_at, :type ]

  end

  def self.down
    drop_table :contents
  end
end
