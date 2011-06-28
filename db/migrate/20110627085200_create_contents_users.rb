class CreateContentsUsers < ActiveRecord::Migration
  def self.up
    create_table :contents_users do |t|
      t.references :content
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :contents_users
  end
end
