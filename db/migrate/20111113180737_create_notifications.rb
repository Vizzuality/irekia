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

    add_index :notifications, [:item_id,   :item_type]
    add_index :notifications, [:parent_id, :parent_type]
  end

  def self.down
    drop_table :notifications
  end
end
