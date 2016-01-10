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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151215153156) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "cube"
  enable_extension "earthdistance"

  create_table "activities", force: :cascade do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "addresses", force: :cascade do |t|
    t.string "address"
    t.string "zip_code"
    t.string "city"
    t.string "state"
    t.string "country"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "favorites", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "faved_id"
    t.string   "faved_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "newsletter_subscriptions", force: :cascade do |t|
    t.string   "email"
    t.integer  "status",     default: 0
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photo_reports", force: :cascade do |t|
    t.integer  "photo_id"
    t.integer  "reporter_id"
    t.string   "reporter_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "photos", force: :cascade do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "image"
    t.string   "caption"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "restaurant_id"
    t.integer  "favorites_count", default: 0
    t.integer  "status",          default: 0
    t.datetime "deleted_at"
  end

  create_table "phrasing_phrase_versions", force: :cascade do |t|
    t.integer  "phrasing_phrase_id"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "phrasing_phrase_versions", ["phrasing_phrase_id"], name: "index_phrasing_phrase_versions_on_phrasing_phrase_id", using: :btree

  create_table "phrasing_phrases", force: :cascade do |t|
    t.string   "locale"
    t.string   "key"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id", using: :btree
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id", using: :btree

  create_table "restaurant_owners", force: :cascade do |t|
    t.string   "email",                         default: "", null: false
    t.string   "encrypted_password",            default: "", null: false
    t.string   "name",                          default: ""
    t.date     "birthday"
    t.integer  "restaurant_id"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                 default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "registration_status",           default: 0
    t.integer  "ownership_verification_status", default: 0
    t.integer  "address_id"
    t.string   "phone"
    t.string   "website"
  end

  add_index "restaurant_owners", ["email"], name: "index_restaurant_owners_on_email", unique: true, using: :btree
  add_index "restaurant_owners", ["reset_password_token"], name: "index_restaurant_owners_on_reset_password_token", unique: true, using: :btree

  create_table "restaurants", force: :cascade do |t|
    t.string   "name"
    t.string   "foursquare_id"
    t.float    "lat"
    t.float    "lng"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "photo"
    t.integer  "favorites_count"
    t.string   "restaurants_request_id"
    t.string   "phone_number"
    t.string   "email"
    t.string   "website"
    t.string   "ownership_document"
    t.integer  "address_id"
  end

  create_table "restaurants_requests", force: :cascade do |t|
    t.float    "lat"
    t.float    "lng"
    t.integer  "radius"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "super_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role"
  end

  add_index "super_users", ["email"], name: "index_super_users_on_email", unique: true, using: :btree
  add_index "super_users", ["reset_password_token"], name: "index_super_users_on_reset_password_token", unique: true, using: :btree

  create_table "tag_categories", force: :cascade do |t|
    t.string "name"
  end

  create_table "tag_report_actions", force: :cascade do |t|
    t.integer  "photo_id"
    t.integer  "tag_report_id"
    t.string   "tag_suggestion"
    t.integer  "action"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "tag_reports", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "reporter_id"
    t.string   "reporter_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
    t.integer "category_id"
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                      default: ""
    t.string   "encrypted_password",         default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",              default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.string   "provider"
    t.string   "uid"
    t.string   "auth_token"
    t.string   "provider_profile_picture"
    t.string   "custom_profile_picture"
    t.string   "location"
    t.integer  "radius"
    t.boolean  "private_faved_photos"
    t.string   "auth_token_secret"
    t.integer  "follower_count"
    t.integer  "following_count"
    t.integer  "status",                     default: 0
    t.boolean  "flagged",                    default: false
    t.integer  "favorite_restaurants_count", default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
