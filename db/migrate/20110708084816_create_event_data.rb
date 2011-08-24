class CreateEventData < ActiveRecord::Migration
  def self.up
    create_table :event_data do |t|
      t.references :event

      t.datetime :event_date
      t.string :title
      t.string :subtitle
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :event_data
  end
end
