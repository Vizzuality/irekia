class CreateContents < ActiveRecord::Migration
  def self.up
    create_table :contents do |t|
      t.references :content_status

      t.integer :related_content_id
      t.string   :name
      t.string   :type
      t.string   :tags
      t.string   :title
      t.text     :body
      t.datetime :published_at

      t.timestamps
    end
  end

  def self.down
    drop_table :contents
  end
end
