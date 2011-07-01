class CreateContentStatuses < ActiveRecord::Migration
  def self.up
    create_table :content_statuses do |t|
      t.string :name
      t.string :translation_key

      t.timestamps
    end
    ContentStatus.create_translation_table! :name => :string
  end

  def self.down
    drop_table :content_statuses
    ContentStatus.drop_translation_table!
  end
end
