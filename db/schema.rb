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

ActiveRecord::Schema.define(version: 2019_05_05_003228) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.integer "round_number"
    t.integer "find_partner_timer"
    t.integer "selfie_timer"
    t.integer "question_timer"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.integer "game_round_now", default: 0
    t.index ["user_id"], name: "index_games_on_user_id"
  end

  create_table "lists", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "game_id"
    t.string "round_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_lists_on_game_id"
    t.index ["user_id"], name: "index_lists_on_user_id"
  end

  create_table "pairs", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "list_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["list_id"], name: "index_pairs_on_list_id"
    t.index ["user_id"], name: "index_pairs_on_user_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.bigint "game_id"
    t.bigint "task_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_rounds_on_game_id"
    t.index ["task_id"], name: "index_rounds_on_task_id"
  end

  create_table "subscribers", force: :cascade do |t|
    t.bigint "game_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_subscribers_on_game_id"
    t.index ["user_id"], name: "index_subscribers_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "selfie"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "openid"
  end

  add_foreign_key "games", "users"
  add_foreign_key "lists", "games"
  add_foreign_key "lists", "users"
  add_foreign_key "pairs", "lists"
  add_foreign_key "pairs", "users"
  add_foreign_key "rounds", "games"
  add_foreign_key "rounds", "tasks"
  add_foreign_key "subscribers", "games"
  add_foreign_key "subscribers", "users"
end
