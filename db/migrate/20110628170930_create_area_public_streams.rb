class CreateAreaPublicStreams < ActiveRecord::Migration
  def self.up
    create_table :area_public_streams do |t|
      t.references :area
      t.text :message
      t.string :event_type
      t.integer :event_id
      t.datetime :published_at
      t.string :link

      t.timestamps
    end

    add_index :area_public_streams, :event_type
    add_index :area_public_streams, :event_id
    add_index :area_public_streams, :published_at
  end

  def self.down
    drop_table :area_public_streams
  end
end
