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

ActiveRecord::Schema[7.2].define(version: 2024_12_05_115727) do
  create_table "admins", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password"
    t.string "avator"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "url"
  end

  create_table "announcements", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "date"
    t.string "content"
    t.integer "publisher"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
  end

  create_table "businesses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.integer "tag"
    t.float "score"
    t.string "email"
    t.string "password"
    t.string "avator"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "url"
  end

  create_table "comments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "post_id"
    t.integer "publisher"
    t.string "publisher_type"
    t.string "date"
    t.string "content"
    t.integer "likes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "commodities", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.float "price"
    t.float "score"
    t.string "introduction"
    t.bigint "business_id"
    t.string "homepage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rating_count"
    t.string "url"
    t.index ["business_id"], name: "index_commodities_on_business_id"
  end

  create_table "posts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "publisher"
    t.string "publisher_type"
    t.string "date"
    t.integer "likes"
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "image"
    t.string "url"
  end

  create_table "preferences", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "preference1"
    t.string "preference2"
    t.string "preference3"
    t.string "preference4"
    t.string "preference5"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "preferable_type", null: false
    t.bigint "preferable_id", null: false
    t.index ["preferable_type", "preferable_id"], name: "index_preferences_on_preferable"
  end

  create_table "tags", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "tag1"
    t.string "tag2"
    t.string "tag3"
    t.string "tag4"
    t.string "tag5"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "business_id", null: false
    t.index ["business_id"], name: "index_tags_on_business_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password"
    t.string "avator"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "url"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name", unique: true
  end

  add_foreign_key "commodities", "businesses"
  add_foreign_key "tags", "businesses"
end
