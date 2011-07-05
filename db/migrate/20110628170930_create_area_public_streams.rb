class CreateAreaPublicStreams < ActiveRecord::Migration
  def self.up
    create_table :area_public_streams do |t|
      t.references :area
      t.text :message
      t.string :event_type
      t.integer :event_id
      t.string :link

      t.timestamps
    end
  end

  def self.down
    drop_table :area_public_streams
  end
end
