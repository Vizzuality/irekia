class CreateStatusMessageData < ActiveRecord::Migration
  def self.up
    create_table :status_message_data do |t|
      t.references :status_message
      t.string :message

      t.timestamps
    end

    add_index :status_message_data, :status_message_id
  end

  def self.down
    drop_table :status_message_data
  end
end
