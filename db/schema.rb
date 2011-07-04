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

ActiveRecord::Schema.define(:version => 20110701132855) do

  create_table "area_public_streams", :force => true do |t|
    t.integer  "area_id"
    t.string   "message"
    t.string   "event_type"
    t.integer  "event_id"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "areas", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "areas_contents", :force => true do |t|
    t.integer  "area_id"
    t.integer  "content_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "areas_users", :force => true do |t|
    t.integer  "area_id"
    t.integer  "user_id"
    t.integer  "hierarchy"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "content_statuses", :force => true do |t|
    t.string   "name"
    t.string   "translation_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contents", :force => true do |t|
    t.integer  "content_status_id"
    t.integer  "related_content_id"
    t.string   "name"
    t.string   "type"
    t.string   "tags"
    t.string   "title"
    t.text     "body"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contents_users", :force => true do |t|
    t.integer  "content_id"
    t.integer  "user_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "follows", :force => true do |t|
    t.integer  "user_id"
    t.integer  "follow_item_id"
    t.string   "follow_item_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "geometry_columns", :id => false, :force => true do |t|
    t.string  "f_table_catalog",   :limit => 256, :null => false
    t.string  "f_table_schema",    :limit => 256, :null => false
    t.string  "f_table_name",      :limit => 256, :null => false
    t.string  "f_geometry_column", :limit => 256, :null => false
    t.integer "coord_dimension",                  :null => false
    t.integer "srid",                             :null => false
    t.string  "type",              :limit => 30,  :null => false
  end

  create_table "images", :force => true do |t|
    t.integer  "image_gallery_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "participations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "content_id"
    t.string   "name"
    t.string   "type"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "role_translations", :force => true do |t|
    t.integer  "role_id"
    t.string   "locale"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "role_translations", ["role_id"], :name => "index_role_translations_on_role_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sex_translations", :force => true do |t|
    t.integer  "sex_id"
    t.string   "locale"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sex_translations", ["sex_id"], :name => "index_sex_translations_on_sex_id"

  create_table "sexes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spatial_ref_sys", :id => false, :force => true do |t|
    t.integer "srid",                      :null => false
    t.string  "auth_name", :limit => 256
    t.integer "auth_srid"
    t.string  "srtext",    :limit => 2048
    t.string  "proj4text", :limit => 2048
  end

  create_table "title_translations", :force => true do |t|
    t.integer  "title_id"
    t.string   "locale"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "title_translations", ["title_id"], :name => "index_title_translations_on_title_id"

  create_table "titles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_private_streams", :force => true do |t|
    t.integer  "user_id"
    t.string   "message"
    t.string   "event_type"
    t.integer  "event_id"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_public_streams", :force => true do |t|
    t.integer  "user_id"
    t.string   "message"
    t.string   "event_type"
    t.integer  "event_id"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.integer  "role_id"
    t.integer  "sex_id"
    t.integer  "title_id"
    t.string   "name"
    t.string   "lastname"
    t.date     "birthday"
    t.text     "description"
    t.string   "facebook_token"
    t.string   "twitter_token"
    t.datetime "last_connection"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
