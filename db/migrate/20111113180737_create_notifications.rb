class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|
      t.references :user
      t.integer    :item_id
      t.string     :item_type
      t.integer    :parent_id
      t.string     :parent_type

      t.timestamps
    end

    add_index :notifications, [:user_id, :item_id, :item_type], :unique => true
  end

  def self.down
    drop_table :notifications
  end
end
