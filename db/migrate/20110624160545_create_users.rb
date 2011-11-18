class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.references  :role
      t.references :title

      t.string   :name
      t.string   :lastname
      t.date     :birthday
      t.text     :description
      t.text     :description_1
      t.text     :description_2
      t.boolean  :is_woman,                                                      :default => false
      t.integer  :province_id
      t.string   :province
      t.integer  :city_id
      t.string   :city
      t.string   :postal_code
      t.string   :facebook_oauth_token
      t.string   :facebook_oauth_token_secret
      t.string   :twitter_username
      t.string   :twitter_oauth_token
      t.string   :twitter_oauth_token_secret
      t.boolean  :inactive,                                                      :default => false
      t.boolean  :first_time,                                                    :default => true
      t.string   :locale,                                                        :default => 'es'

      t.integer :follows_count,                                                  :default => 0
      t.integer :areas_users_count,                                              :default => 0

      t.integer :proposals_count,                                                :default => 0
      t.integer :arguments_count,                                                :default => 0
      t.integer :votes_count,                                                    :default => 0
      t.integer :questions_count,                                                :default => 0
      t.integer :answers_count,                                                  :default => 0
      t.integer :answer_requests_count,                                          :default => 0
      t.integer :events_count,                                                   :default => 0
      t.integer :news_count,                                                     :default => 0
      t.integer :photos_count,                                                   :default => 0
      t.integer :videos_count,                                                   :default => 0
      t.integer :status_messages_count,                                          :default => 0
      t.integer :tweets_count,                                                   :default => 0
      t.integer :comments_count,                                                 :default => 0

      t.integer :private_proposals_count,                                        :default => 0
      t.integer :private_arguments_count,                                        :default => 0
      t.integer :private_votes_count,                                            :default => 0
      t.integer :private_questions_count,                                        :default => 0
      t.integer :private_answers_count,                                          :default => 0
      t.integer :private_answer_requests_count,                                  :default => 0
      t.integer :private_events_count,                                           :default => 0
      t.integer :private_news_count,                                             :default => 0
      t.integer :private_photos_count,                                           :default => 0
      t.integer :private_videos_count,                                           :default => 0
      t.integer :private_status_messages_count,                                  :default => 0
      t.integer :private_tweets_count,                                           :default => 0
      t.integer :private_comments_count,                                         :default => 0


      t.integer :new_news_count,                                                 :default => 0
      t.integer :new_events_count,                                               :default => 0
      t.integer :new_proposals_count,                                            :default => 0
      t.integer :new_answers_count,                                              :default => 0
      t.integer :new_comments_count,                                             :default => 0
      t.integer :new_votes_count,                                                :default => 0
      t.integer :new_arguments_count,                                            :default => 0
      t.integer :new_questions_count,                                            :default => 0
      t.integer :new_answer_requests_count,                                      :default => 0
      t.integer :new_contents_users_count,                                       :default => 0
      t.integer :new_follows_count,                                              :default => 0

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

    add_index :users, :id
    add_index :users, :email,                                                :unique => true
    add_index :users, :twitter_username,                                     :unique => true
    add_index :users, :reset_password_token,                                 :unique => true
    # add_index :users, :confirmation_token,                                 :unique => true
    # add_index :users, :unlock_token,                                       :unique => true
    # add_index :users, :authentication_token,                               :unique => true

    add_index :users, [:facebook_oauth_token, :facebook_oauth_token_secret], :unique => true, :name => 'facebook_credentials'
    add_index :users, [:twitter_oauth_token, :twitter_oauth_token_secret],   :unique => true, :name => 'twitter_credentials'
  end

  def self.down
    drop_table :users
  end
end
