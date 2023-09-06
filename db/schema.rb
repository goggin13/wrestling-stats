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

ActiveRecord::Schema[7.0].define(version: 2023_09_06_034917) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "advocate_employees", force: :cascade do |t|
    t.string "name"
    t.string "first"
    t.string "last"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "shift_label"
    t.string "status"
  end

  create_table "advocate_shifts", force: :cascade do |t|
    t.date "date", null: false
    t.integer "start"
    t.integer "duration"
    t.integer "employee_id", null: false
    t.string "raw_shift_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "colleges", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "dual_rank"
    t.integer "tournament_rank"
    t.string "url"
  end

  create_table "etoh_drinks", force: :cascade do |t|
    t.datetime "consumed_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.integer "oz", default: 12
    t.integer "abv", default: 5
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "metabolized_at", precision: nil
  end

  create_table "matches", force: :cascade do |t|
    t.date "date", null: false
    t.integer "home_team_id", null: false
    t.integer "away_team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "time"
    t.string "watch_on"
  end

  create_table "olympics_matches", force: :cascade do |t|
    t.integer "bout_number", null: false
    t.integer "team_1_id", null: false
    t.integer "team_2_id", null: false
    t.integer "winning_team_id"
    t.string "event", null: false
    t.integer "bp_cups_remaining"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "now_playing", default: false
  end

  create_table "olympics_teams", force: :cascade do |t|
    t.string "name"
    t.integer "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wrestlers", force: :cascade do |t|
    t.string "name"
    t.string "college"
    t.integer "rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "weight"
    t.bigint "college_id", null: false
    t.string "year"
    t.index ["college_id"], name: "index_wrestlers_on_college_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "wrestlers", "colleges"
end
