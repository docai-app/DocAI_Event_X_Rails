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

ActiveRecord::Schema[7.0].define(version: 2024_10_31_065621) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "form_submissions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "form_id", null: false
    t.jsonb "submission_data", default: {}, null: false
    t.uuid "qrcode_id", default: -> { "gen_random_uuid()" }, null: false
    t.boolean "checked_in", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "confirmation_email_sent"
    t.datetime "confirmation_email_sent_at"
    t.index ["form_id"], name: "index_form_submissions_on_form_id"
    t.index ["qrcode_id"], name: "index_form_submissions_on_qrcode_id", unique: true
    t.index ["submission_data"], name: "index_form_submissions_on_submission_data", using: :gin
  end

  create_table "forms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "json_schema", default: {}
    t.jsonb "ui_schema", default: {}
    t.jsonb "form_data", default: {}
  end

  add_foreign_key "form_submissions", "forms"
end
