class CreateUserPrivateStreams < ActiveRecord::Migration
  def self.up
    create_table :user_private_streams do |t|
      t.references :user
      t.references :author
      t.text       :message
      t.string     :event_type
      t.integer    :event_id
      t.datetime   :published_at
      t.boolean    :moderated,         :default => false
      t.boolean    :notification_sent, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :user_private_streams
  end
end
