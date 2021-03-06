class CreateEventData < ActiveRecord::Migration
  def self.up
    create_table :event_data do |t|
      t.references :event

      t.datetime :event_date
      t.integer  :duration
      t.string   :place
      t.string   :title
      t.string   :subtitle
      t.text     :body
      t.text     :html
      t.string   :news_url
      t.string   :external_id

      t.timestamps
    end

    add_index :event_data, :event_id
    add_index :event_data, :event_date
  end

  def self.down
    drop_table :event_data
  end
end
