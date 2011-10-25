class CreateTweetData < ActiveRecord::Migration
  def self.up
    create_table :tweet_data do |t|
      t.references :tweet
      t.string :message
      t.string :status_id
      t.string :username

      t.timestamps
    end

    add_index :tweet_data, :tweet_id
  end

  def self.down
    drop_table :tweet_data
  end
end
