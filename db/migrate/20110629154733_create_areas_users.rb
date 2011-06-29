class CreateAreasUsers < ActiveRecord::Migration
  def self.up
    create_table :areas_users do |t|
      t.references :area
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :areas_users
  end
end
