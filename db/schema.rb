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

ActiveRecord::Schema[7.0].define(version: 2022_09_02_132711) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "transactions", force: :cascade do |t|
    t.float "bank_fee", default: 0.0, null: false
    t.float "old_balance", default: 0.0, null: false
    t.float "new_balance", default: 0.0, null: false
    t.float "destination_account_old_balance"
    t.float "destination_account_new_balance"
    t.string "transaction_type", null: false
    t.float "amount", default: 0.0, null: false
    t.bigint "user_id", null: false
    t.bigint "destination_account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["destination_account_id"], name: "index_transactions_on_destination_account_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "balance", default: 0.0, null: false
    t.string "full_name", null: false
    t.string "address"
    t.string "phone_number"
    t.string "account_number", default: "00000", null: false
    t.string "cpf", null: false
    t.datetime "deleted_at"
    t.index ["account_number"], name: "index_users_on_account_number"
    t.index ["cpf"], name: "index_users_on_cpf"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "transactions", "users"
  add_foreign_key "transactions", "users", column: "destination_account_id"
end
