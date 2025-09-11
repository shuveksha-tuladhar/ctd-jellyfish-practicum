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

<<<<<<< HEAD


ActiveRecord::Schema[8.0].define(version: 2025_09_09_200939) do


=======
<<<<<<< Updated upstream
ActiveRecord::Schema[8.0].define(version: 2025_08_27_204303) do
=======
ActiveRecord::Schema[8.0].define(version: 2025_09_09_200939) do
>>>>>>> Stashed changes
>>>>>>> c141915 (JPROR-31 Resolves conflict)
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

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

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "expense_users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "expense_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expense_id"], name: "index_expense_users_on_expense_id"
    t.index ["user_id"], name: "index_expense_users_on_user_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.string "title"
    t.decimal "amount", precision: 10, scale: 2
    t.string "split_type"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "user_group_id"
    t.index ["user_group_id"], name: "index_expenses_on_user_group_id"
    t.index ["user_id"], name: "index_expenses_on_user_id"
  end

  create_table "friendships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "friend_id", null: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["friend_id"], name: "index_friendships_on_friend_id"
    t.index ["user_id", "friend_id"], name: "index_friendships_on_user_id_and_friend_id", unique: true
    t.index ["user_id"], name: "index_friendships_on_user_id"
  end

  create_table "group_members", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "user_group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_group_id"], name: "index_group_members_on_user_group_id"
    t.index ["user_id"], name: "index_group_members_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "expense_id", null: false
    t.bigint "payer_id", null: false
    t.bigint "payee_id", null: false
    t.bigint "user_group_id"
    t.decimal "owed_amount"
    t.decimal "paid_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expense_id"], name: "index_payments_on_expense_id"
    t.index ["payee_id"], name: "index_payments_on_payee_id"
    t.index ["payer_id"], name: "index_payments_on_payer_id"
    t.index ["user_group_id"], name: "index_payments_on_user_group_id"
  end

  create_table "user_groups", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.bigint "created_by_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_user_id"], name: "index_user_groups_on_created_by_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone_number"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "expense_users", "expenses"
  add_foreign_key "expense_users", "users"
  add_foreign_key "expenses", "user_groups"
  add_foreign_key "expenses", "users"
  add_foreign_key "friendships", "users"
  add_foreign_key "friendships", "users", column: "friend_id"
  add_foreign_key "group_members", "user_groups"
  add_foreign_key "group_members", "users"
  add_foreign_key "payments", "expenses"
  add_foreign_key "payments", "user_groups"
  add_foreign_key "payments", "users", column: "payee_id"
  add_foreign_key "payments", "users", column: "payer_id"
  add_foreign_key "user_groups", "users", column: "created_by_user_id"
end
