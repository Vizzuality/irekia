class CreateAreas < ActiveRecord::Migration
  def self.up
    create_table :areas do |t|
      t.string  :name
      t.string  :name_es
      t.string  :name_eu
      t.string  :name_en
      t.text    :description
      t.text    :description_1
      t.text    :description_2
      t.integer :external_id
      t.string  :slug_es
      t.string  :slug_eu
      t.string  :slug_en

      t.integer :areas_users_count,        :default => 0
      t.integer :follows_count,            :default => 0
      t.integer :proposals_count,          :default => 0
      t.integer :arguments_count,          :default => 0
      t.integer :votes_count,              :default => 0
      t.integer :questions_count,          :default => 0
      t.integer :answers_count,            :default => 0
      t.integer :answer_requests_count,    :default => 0
      t.integer :events_count,             :default => 0
      t.integer :news_count,               :default => 0
      t.integer :photos_count,             :default => 0
      t.integer :videos_count,             :default => 0
      t.integer :status_messages_count,    :default => 0
      t.integer :tweets_count,             :default => 0
      t.integer :comments_count,           :default => 0

      t.timestamps
    end

    add_index :areas, :external_id
    add_index :areas, :slug_es,        :unique => true
    add_index :areas, :slug_eu,        :unique => true
    add_index :areas, :slug_en,        :unique => true
  end

  def self.down
    drop_table :areas
  end
end
