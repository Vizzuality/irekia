class CreateAreasUsers < ActiveRecord::Migration
  def self.up
    create_table :areas_users do |t|
      t.references :area
      t.references :user
      t.integer :display_order

      t.timestamps
    end

    add_index :areas_users, :display_order
  end

  def self.down
    drop_table :areas_users
  end
end
