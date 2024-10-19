# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_10_19_071616) do
  create_table "admins", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password"
    t.string "avator"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["name"], name: "index_admins_on_name", unique: true
  end

  create_table "announcements", force: :cascade do |t|
    t.string "date"
    t.string "content"
    t.integer "publisher"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "businesses", force: :cascade do |t|
    t.string "name"
    t.integer "tag"
    t.float "score"
    t.string "email"
    t.string "password"
    t.string "avator"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "post_id"
    t.integer "publisher"
    t.string "publisher_type"
    t.string "date"
    t.string "content"
    t.integer "likes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "commodities", force: :cascade do |t|
    t.string "name"
    t.float "price"
    t.float "score"
    t.string "introduction"
    t.integer "business_id"
    t.string "homepage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_id"], name: "index_commodities_on_business_id"
  end

  create_table "posts", force: :cascade do |t|
    t.integer "publisher"
    t.string "publisher_type"
    t.string "date"
    t.integer "likes"
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "preferences", force: :cascade do |t|
    t.string "preference1"
    t.string "preference2"
    t.string "preference3"
    t.string "preference4"
    t.string "preference5"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "preferable_type", null: false
    t.integer "preferable_id", null: false
    t.index ["preferable_type", "preferable_id"], name: "index_preferences_on_preferable"
  end

  create_table "tags", force: :cascade do |t|
    t.string "tag1"
    t.string "tag2"
    t.string "tag3"
    t.string "tag4"
    t.string "tag5"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "business_id", null: false
    t.index ["business_id"], name: "index_tags_on_business_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password"
    t.string "avator"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
  end

  add_foreign_key "commodities", "businesses"
  add_foreign_key "tags", "businesses"
end
