class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.references  :role
      t.references :sex
      t.references :title

      t.string   :name
      t.string   :lastname
      t.date     :birthday
      t.text     :description
      t.string   :facebook_token
      t.string   :twitter_token
      t.datetime :last_connection

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
