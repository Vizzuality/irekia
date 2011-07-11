class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.references  :role
      t.references :title

      t.string   :name
      t.date     :birthday
      t.text     :description
      t.boolean  :is_woman, :default => false
      t.string   :facebook_token
      t.string   :twitter_token
      t.datetime :last_connection
      t.boolean  :inactive, :default => false

      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable

      # t.encryptable
      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable


      t.timestamps
    end

    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    # add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true
    # add_index :users, :authentication_token, :unique => true
  end

  def self.down
    drop_table :users
  end
end
