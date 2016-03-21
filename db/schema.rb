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

ActiveRecord::Schema.define(version: 20160321173144) do

  create_table "announcements", force: :cascade do |t|
    t.text     "content",    limit: 65535
    t.integer  "user_id",    limit: 4
    t.boolean  "active"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "post_meta", force: :cascade do |t|
    t.integer  "post_id",    limit: 4
    t.string   "meta_key",   limit: 255
    t.text     "value",      limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "author",          limit: 4
    t.datetime "create_date_gmt"
    t.datetime "update_date_gmt"
    t.text     "title",           limit: 65535
    t.text     "content",         limit: 65535
    t.string   "name",            limit: 255
    t.string   "status",          limit: 255
    t.datetime "live_date"
    t.text     "guid",            limit: 65535
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end