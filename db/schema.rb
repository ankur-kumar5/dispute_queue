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

ActiveRecord::Schema[8.1].define(version: 2026_02_16_123839) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "case_actions", force: :cascade do |t|
    t.string "action"
    t.datetime "created_at", null: false
    t.jsonb "details"
    t.bigint "dispute_id", null: false
    t.text "note"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["dispute_id"], name: "index_case_actions_on_dispute_id"
    t.index ["user_id"], name: "index_case_actions_on_user_id"
  end

  create_table "charges", force: :cascade do |t|
    t.integer "amount_cents", null: false
    t.datetime "created_at", null: false
    t.string "currency", null: false
    t.string "external_id", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_charges_on_external_id", unique: true
  end

  create_table "disputes", force: :cascade do |t|
    t.integer "amount_cents", null: false
    t.bigint "charge_id", null: false
    t.datetime "closed_at"
    t.datetime "created_at", null: false
    t.string "currency", null: false
    t.string "external_id"
    t.jsonb "external_payload"
    t.datetime "opened_at"
    t.string "status", default: "open", null: false
    t.datetime "updated_at", null: false
    t.index ["charge_id"], name: "index_disputes_on_charge_id"
    t.index ["external_id"], name: "index_disputes_on_external_id", unique: true
    t.index ["status"], name: "index_disputes_on_status"
  end

  create_table "evidences", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "dispute_id", null: false
    t.string "kind"
    t.jsonb "metadata"
    t.datetime "updated_at", null: false
    t.index ["dispute_id"], name: "index_evidences_on_dispute_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.string "role", default: "read_only", null: false
    t.string "time_zone", default: "UTC"
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  create_table "webhook_events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "event_id"
    t.string "event_type"
    t.datetime "occurred_at"
    t.jsonb "payload"
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_webhook_events_on_event_id", unique: true
    t.index ["occurred_at"], name: "index_webhook_events_on_occurred_at"
  end

  add_foreign_key "case_actions", "disputes"
  add_foreign_key "case_actions", "users"
  add_foreign_key "disputes", "charges"
  add_foreign_key "evidences", "disputes"
  add_foreign_key "sessions", "users"
end
