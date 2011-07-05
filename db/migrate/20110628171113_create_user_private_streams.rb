class CreateUserPrivateStreams < ActiveRecord::Migration
  def self.up
    create_table :user_private_streams do |t|
      t.references :user
      t.text :message
      t.string :event_type
      t.integer :event_id
      t.string :link

      t.timestamps
    end
  end

  def self.down
    drop_table :user_private_streams
  end
end
