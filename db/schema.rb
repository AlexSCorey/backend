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

ActiveRecord::Schema.define(version: 2018_10_10_021501) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "availability_processes", force: :cascade do |t|
    t.bigint "calendar_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["calendar_id"], name: "index_availability_processes_on_calendar_id"
  end

  create_table "availability_requests", force: :cascade do |t|
    t.bigint "user_id"
    t.boolean "complete"
    t.string "api_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "availability_process_id"
    t.index ["availability_process_id"], name: "index_availability_requests_on_availability_process_id"
    t.index ["user_id"], name: "index_availability_requests_on_user_id"
  end

  create_table "availability_responses", force: :cascade do |t|
    t.bigint "availability_request_id"
    t.bigint "shift_id"
    t.boolean "available"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["availability_request_id"], name: "index_availability_responses_on_availability_request_id"
    t.index ["shift_id"], name: "index_availability_responses_on_shift_id"
  end

  create_table "calendars", force: :cascade do |t|
    t.string "name"
    t.float "employee_hour_threshold_daily"
    t.float "employee_hour_threshold_weekly"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "time_zone"
    t.boolean "daylight_savings"
  end

  create_table "invitations", force: :cascade do |t|
    t.bigint "user_id"
    t.string "api_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_invitations_on_user_id"
  end

  create_table "notes", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "calendar_id"
    t.string "text"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["calendar_id"], name: "index_notes_on_calendar_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "calendar_id"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["calendar_id"], name: "index_roles_on_calendar_id"
    t.index ["user_id"], name: "index_roles_on_user_id"
  end

  create_table "shifts", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.bigint "calendar_id"
    t.integer "capacity"
    t.boolean "published"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["calendar_id"], name: "index_shifts_on_calendar_id"
  end

  create_table "swaps", force: :cascade do |t|
    t.bigint "requesting_user_id"
    t.bigint "accepting_user_id"
    t.bigint "shift_id"
    t.string "api_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["accepting_user_id"], name: "index_swaps_on_accepting_user_id"
    t.index ["requesting_user_id"], name: "index_swaps_on_requesting_user_id"
    t.index ["shift_id"], name: "index_swaps_on_shift_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "phone_number"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "api_token"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
  end

  create_table "usershifts", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "shift_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shift_id"], name: "index_usershifts_on_shift_id"
    t.index ["user_id"], name: "index_usershifts_on_user_id"
  end

end
