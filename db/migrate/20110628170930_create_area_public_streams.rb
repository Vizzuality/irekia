class CreateAreaPublicStreams < ActiveRecord::Migration
  def self.up
    create_table :area_public_streams do |t|
      t.references :area
      t.references :author
      t.text       :message
      t.string     :event_type
      t.integer    :event_id
      t.datetime   :published_at
      t.boolean    :moderated,   :default => false

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
