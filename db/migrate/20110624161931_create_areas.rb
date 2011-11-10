class CreateAreas < ActiveRecord::Migration
  def self.up
    create_table :areas do |t|
      t.string :name
      t.text :description

      t.integer :areas_users_count, :default => 0
      t.integer :follows_count, :default => 0
      t.integer :proposals_count, :default => 0
      t.integer :questions_count, :default => 0
      t.integer :answers_count, :default => 0
      t.integer :events_count, :default => 0
      t.integer :news_count, :default => 0
      t.integer :photos_count, :default => 0
      t.integer :videos_count, :default => 0
      t.integer :statuses_count, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :areas
  end
end
