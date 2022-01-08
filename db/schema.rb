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

ActiveRecord::Schema.define(version: 2022_01_04_052717) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "scope"
    t.string "target_type"
    t.integer "target_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "content"
    t.index ["target_type", "target_id"], name: "index_actions_on_target_type_and_target_id"
    t.index ["user_id"], name: "index_actions_on_user_id"
  end

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
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "bookings", force: :cascade do |t|
    t.integer "tour_id"
    t.integer "user_id"
    t.integer "adults"
    t.integer "children", default: 0
    t.datetime "departure_date", precision: 6
    t.decimal "total", precision: 9, scale: 2
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tour_id"], name: "index_bookings_on_tour_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "user_id"
    t.string "commentable_type"
    t.integer "commentable_id"
    t.text "body"
    t.boolean "state", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "booking_id"
    t.integer "hearts"
    t.text "body"
    t.boolean "state", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["booking_id"], name: "index_reviews_on_booking_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.integer "tour_tags_count", default: 0
    t.index ["name"], name: "index_tags_on_name"
  end

  create_table "tour_tags", force: :cascade do |t|
    t.integer "tag_id"
    t.integer "tour_id"
    t.index ["tag_id"], name: "index_tour_tags_on_tag_id"
    t.index ["tour_id", "tag_id"], name: "index_tour_tags_on_tour_id_and_tag_id", unique: true
    t.index ["tour_id"], name: "index_tour_tags_on_tour_id"
  end

  create_table "tour_vehicles", force: :cascade do |t|
    t.integer "vehicle_id"
    t.integer "tour_id"
    t.index ["tour_id", "vehicle_id"], name: "index_tour_vehicles_on_tour_id_and_vehicle_id", unique: true
    t.index ["tour_id"], name: "index_tour_vehicles_on_tour_id"
    t.index ["vehicle_id"], name: "index_tour_vehicles_on_vehicle_id"
  end

  create_table "tours", force: :cascade do |t|
    t.integer "kind"
    t.string "name"
    t.text "description"
    t.string "time"
    t.decimal "quantity", precision: 3, scale: 1, default: "0.0"
    t.integer "limit"
    t.datetime "begin_date", precision: 6
    t.datetime "return_date", precision: 6
    t.decimal "price", precision: 9, scale: 2
    t.string "departure"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "travellers", force: :cascade do |t|
    t.integer "booking_id"
    t.string "name"
    t.string "email"
    t.string "phone_number"
    t.string "note"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "password_digest"
    t.string "email"
    t.string "phone_number"
    t.string "address"
    t.date "birthday"
    t.string "activation_digest"
    t.datetime "activated_at", precision: 6
    t.boolean "activated", default: false
    t.boolean "admin", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "reset_password_digest"
    t.datetime "reset_password_sent_at", precision: 6
    t.string "provider"
    t.string "uid"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "index_vehicles_on_name"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
