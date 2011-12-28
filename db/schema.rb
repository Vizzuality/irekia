# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111128124203) do

  create_table "answer_data", :force => true do |t|
    t.integer  "answer_id"
    t.text     "answer_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answer_data", ["answer_id"], :name => "index_answer_data_on_answer_id"

  create_table "answer_opinion_data", :force => true do |t|
    t.integer  "answer_opinion_id"
    t.boolean  "satisfactory",      :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answer_opinion_data", ["answer_opinion_id"], :name => "index_answer_opinion_data_on_answer_opinion_id"

  create_table "area_public_streams", :force => true do |t|
    t.integer  "area_id"
    t.integer  "author_id"
    t.text     "message"
    t.string   "event_type"
    t.integer  "event_id"
    t.datetime "published_at"
    t.boolean  "moderated",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "area_public_streams", ["event_id"], :name => "index_area_public_streams_on_event_id"
  add_index "area_public_streams", ["event_type"], :name => "index_area_public_streams_on_event_type"
  add_index "area_public_streams", ["published_at"], :name => "index_area_public_streams_on_published_at"

  create_table "areas", :force => true do |t|
    t.string   "name"
    t.string   "name_es"
    t.string   "name_eu"
    t.string   "name_en"
    t.text     "description"
    t.text     "description_1"
    t.text     "description_2"
    t.integer  "external_id"
    t.string   "slug_es"
    t.string   "slug_eu"
    t.string   "slug_en"
    t.integer  "areas_users_count",     :default => 0
    t.integer  "follows_count",         :default => 0
    t.integer  "proposals_count",       :default => 0
    t.integer  "arguments_count",       :default => 0
    t.integer  "votes_count",           :default => 0
    t.integer  "questions_count",       :default => 0
    t.integer  "answers_count",         :default => 0
    t.integer  "answer_requests_count", :default => 0
    t.integer  "events_count",          :default => 0
    t.integer  "news_count",            :default => 0
    t.integer  "photos_count",          :default => 0
    t.integer  "videos_count",          :default => 0
    t.integer  "status_messages_count", :default => 0
    t.integer  "tweets_count",          :default => 0
    t.integer  "comments_count",        :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "areas", ["external_id"], :name => "index_areas_on_external_id"
  add_index "areas", ["slug_en"], :name => "index_areas_on_slug_en", :unique => true
  add_index "areas", ["slug_es"], :name => "index_areas_on_slug_es", :unique => true
  add_index "areas", ["slug_eu"], :name => "index_areas_on_slug_eu", :unique => true

  create_table "areas_contents", :force => true do |t|
    t.integer  "area_id"
    t.integer  "content_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "areas_users", :force => true do |t|
    t.integer  "area_id"
    t.integer  "user_id"
    t.integer  "display_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "areas_users", ["display_order"], :name => "index_areas_users_on_display_order"

  create_table "argument_data", :force => true do |t|
    t.integer  "argument_id"
    t.boolean  "in_favor",    :default => true
    t.string   "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "argument_data", ["argument_id"], :name => "index_argument_data_on_argument_id"

  create_table "comment_data", :force => true do |t|
    t.integer  "comment_id"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comment_data", ["comment_id"], :name => "index_comment_data_on_comment_id"

  create_table "contents", :force => true do |t|
    t.integer  "user_id"
    t.integer  "related_content_id"
    t.string   "type"
    t.string   "tags"
    t.datetime "published_at"
    t.boolean  "moderated",             :default => false
    t.boolean  "rejected",              :default => false
    t.datetime "moderated_at"
    t.string   "location"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "external_id"
    t.string   "slug"
    t.integer  "comments_count",        :default => 0
    t.integer  "answer_requests_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contents", ["id", "published_at", "type"], :name => "index_contents_on_id_and_published_at_and_type"
  add_index "contents", ["id", "type", "moderated"], :name => "index_contents_on_id_and_type_and_moderated"
  add_index "contents", ["id", "type"], :name => "index_contents_on_id_and_type"
  add_index "contents", ["slug", "type"], :name => "index_contents_on_slug_and_type", :unique => true

  create_table "contents_users", :force => true do |t|
    t.integer  "content_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_data", :force => true do |t|
    t.integer  "event_id"
    t.datetime "event_date"
    t.integer  "duration"
    t.string   "title"
    t.string   "subtitle"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_data", ["event_date"], :name => "index_event_data_on_event_date"
  add_index "event_data", ["event_id"], :name => "index_event_data_on_event_id"

  create_table "follows", :force => true do |t|
    t.integer  "user_id"
    t.integer  "follow_item_id"
    t.string   "follow_item_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "follows", ["follow_item_id"], :name => "index_follows_on_follow_item_id"
  add_index "follows", ["follow_item_type"], :name => "index_follows_on_follow_item_type"

  create_table "images", :force => true do |t|
    t.integer  "photo_id"
    t.integer  "user_id"
    t.integer  "area_id"
    t.integer  "news_data_id"
    t.integer  "proposal_data_id"
    t.integer  "event_data_id"
    t.string   "image"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news_data", :force => true do |t|
    t.integer  "news_id"
    t.integer  "image_id"
    t.string   "title"
    t.string   "subtitle"
    t.text     "body"
    t.string   "source_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "news_data", ["news_id"], :name => "index_news_data_on_news_id"

  create_table "notifications", :force => true do |t|
    t.integer  "user_id"
    t.integer  "item_id"
    t.string   "item_type"
    t.integer  "parent_id"
    t.string   "parent_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notifications", ["item_id", "item_type"], :name => "index_notifications_on_item_id_and_item_type"
  add_index "notifications", ["parent_id", "parent_type"], :name => "index_notifications_on_parent_id_and_parent_type"

  create_table "participations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "content_id"
    t.string   "name"
    t.string   "type"
    t.datetime "published_at"
    t.boolean  "moderated",    :default => false
    t.boolean  "rejected",     :default => false
    t.datetime "moderated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "participations", ["content_id", "moderated", "type"], :name => "index_participations_on_content_id_and_moderated_and_type"
  add_index "participations", ["content_id"], :name => "index_participations_on_content_id"
  add_index "participations", ["moderated"], :name => "index_participations_on_moderated"
  add_index "participations", ["published_at"], :name => "index_participations_on_published_at"
  add_index "participations", ["type"], :name => "index_participations_on_type"

  create_table "proposal_data", :force => true do |t|
    t.integer  "proposal_id"
    t.integer  "area_id"
    t.string   "title"
    t.text     "body"
    t.boolean  "close",         :default => false
    t.integer  "participation", :default => 0
    t.integer  "in_favor",      :default => 0
    t.integer  "against",       :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "proposal_data", ["proposal_id"], :name => "index_proposal_data_on_proposal_id"

  create_table "question_data", :force => true do |t|
    t.integer  "question_id"
    t.integer  "user_id"
    t.integer  "area_id"
    t.text     "question_text"
    t.text     "body"
    t.datetime "answered_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "question_data", ["question_id"], :name => "index_question_data_on_question_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.string   "name_i18n_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "status_message_data", :force => true do |t|
    t.integer  "status_message_id"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "status_message_data", ["status_message_id"], :name => "index_status_message_data_on_status_message_id"

  create_table "titles", :force => true do |t|
    t.string   "name"
    t.text     "translated_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tweet_data", :force => true do |t|
    t.integer  "tweet_id"
    t.string   "message"
    t.string   "status_id"
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tweet_data", ["tweet_id"], :name => "index_tweet_data_on_tweet_id"

  create_table "user_private_streams", :force => true do |t|
    t.integer  "user_id"
    t.integer  "author_id"
    t.text     "message"
    t.string   "event_type"
    t.integer  "event_id"
    t.datetime "published_at"
    t.boolean  "moderated",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_public_streams", :force => true do |t|
    t.integer  "user_id"
    t.integer  "author_id"
    t.text     "message"
    t.string   "event_type"
    t.integer  "event_id"
    t.datetime "published_at"
    t.boolean  "moderated",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.integer  "role_id"
    t.integer  "title_id"
    t.string   "name"
    t.string   "lastname"
    t.date     "birthday"
    t.text     "description"
    t.text     "description_1"
    t.text     "description_2"
    t.boolean  "is_woman",                                     :default => false
    t.integer  "province_id"
    t.string   "province"
    t.integer  "city_id"
    t.string   "city"
    t.string   "postal_code"
    t.string   "salary"
    t.string   "phone_number"
    t.string   "contact_email"
    t.string   "twitter_username"
    t.string   "facebook_username"
    t.string   "facebook_url"
    t.integer  "external_id"
    t.datetime "last_import"
    t.string   "facebook_oauth_token"
    t.string   "facebook_oauth_token_secret"
    t.string   "twitter_oauth_token"
    t.string   "twitter_oauth_token_secret"
    t.boolean  "inactive",                                     :default => false
    t.boolean  "first_time",                                   :default => true
    t.string   "locale",                                       :default => "es"
    t.string   "slug"
    t.integer  "notifications_level",                          :default => 2
    t.integer  "follows_count",                                :default => 0
    t.integer  "areas_users_count",                            :default => 0
    t.integer  "proposals_count",                              :default => 0
    t.integer  "arguments_count",                              :default => 0
    t.integer  "votes_count",                                  :default => 0
    t.integer  "questions_count",                              :default => 0
    t.integer  "answers_count",                                :default => 0
    t.integer  "answer_requests_count",                        :default => 0
    t.integer  "events_count",                                 :default => 0
    t.integer  "news_count",                                   :default => 0
    t.integer  "photos_count",                                 :default => 0
    t.integer  "videos_count",                                 :default => 0
    t.integer  "status_messages_count",                        :default => 0
    t.integer  "tweets_count",                                 :default => 0
    t.integer  "comments_count",                               :default => 0
    t.integer  "private_proposals_count",                      :default => 0
    t.integer  "private_arguments_count",                      :default => 0
    t.integer  "private_votes_count",                          :default => 0
    t.integer  "private_questions_count",                      :default => 0
    t.integer  "private_answers_count",                        :default => 0
    t.integer  "private_answer_requests_count",                :default => 0
    t.integer  "private_events_count",                         :default => 0
    t.integer  "private_news_count",                           :default => 0
    t.integer  "private_photos_count",                         :default => 0
    t.integer  "private_videos_count",                         :default => 0
    t.integer  "private_status_messages_count",                :default => 0
    t.integer  "private_tweets_count",                         :default => 0
    t.integer  "private_comments_count",                       :default => 0
    t.integer  "private_contents_users_count",                 :default => 0
    t.integer  "new_news_count",                               :default => 0
    t.integer  "new_events_count",                             :default => 0
    t.integer  "new_proposals_count",                          :default => 0
    t.integer  "new_answers_count",                            :default => 0
    t.integer  "new_comments_count",                           :default => 0
    t.integer  "new_votes_count",                              :default => 0
    t.integer  "new_arguments_count",                          :default => 0
    t.integer  "new_questions_count",                          :default => 0
    t.integer  "new_answer_requests_count",                    :default => 0
    t.integer  "new_contents_users_count",                     :default => 0
    t.integer  "new_follows_count",                            :default => 0
    t.integer  "new_tweets_count",                             :default => 0
    t.integer  "new_status_messages_count",                    :default => 0
    t.integer  "new_photos_count",                             :default => 0
    t.integer  "new_videos_count",                             :default => 0
    t.string   "email",                                        :default => "",    :null => false
    t.string   "encrypted_password",            :limit => 128, :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["external_id"], :name => "index_users_on_external_id", :unique => true
  add_index "users", ["facebook_oauth_token", "facebook_oauth_token_secret"], :name => "facebook_credentials", :unique => true
  add_index "users", ["id"], :name => "index_users_on_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["slug"], :name => "index_users_on_slug", :unique => true
  add_index "users", ["twitter_oauth_token", "twitter_oauth_token_secret"], :name => "twitter_credentials", :unique => true
  add_index "users", ["twitter_username"], :name => "index_users_on_twitter_username", :unique => true

  create_table "video_data", :force => true do |t|
    t.integer  "video_id"
    t.integer  "answer_data_id"
    t.string   "title"
    t.string   "description"
    t.string   "youtube_url"
    t.string   "vimeo_url"
    t.string   "thumbnail_url"
    t.text     "html"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vote_data", :force => true do |t|
    t.integer  "vote_id"
    t.boolean  "in_favor",   :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vote_data", ["vote_id"], :name => "index_vote_data_on_vote_id"

end
