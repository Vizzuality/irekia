class CreateFollows < ActiveRecord::Migration
  def self.up
    create_table :follows do |t|
      t.references :user

      t.integer :follow_item_id
      t.string :follow_item_type

      t.timestamps
    end
  end

  def self.down
    drop_table :follows
  end
end
