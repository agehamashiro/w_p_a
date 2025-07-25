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

ActiveRecord::Schema[7.2].define(version: 2025_06_13_004527) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dishes", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "suggestion_id", null: false
    t.integer "rating"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "dish_name"
    t.index ["suggestion_id"], name: "index_reviews_on_suggestion_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "suggestions", force: :cascade do |t|
    t.bigint "wine_id", null: false
    t.string "dish_name"
    t.text "ingredients"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "data"
    t.string "image_url"
    t.index ["wine_id"], name: "index_suggestions_on_wine_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wines", force: :cascade do |t|
    t.integer "price"
    t.string "region"
    t.string "variety"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "preference"
    t.string "ingredient"
  end

  add_foreign_key "reviews", "suggestions"
  add_foreign_key "reviews", "users"
  add_foreign_key "suggestions", "wines"
end
