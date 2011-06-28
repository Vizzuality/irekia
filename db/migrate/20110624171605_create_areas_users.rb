class CreateAreasUsers < ActiveRecord::Migration
  def self.up
    create_table :areas_users do |t|
      t.integer :area_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :areas_users
  end
end
