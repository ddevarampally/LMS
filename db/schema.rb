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

ActiveRecord::Schema.define(version: 20170213043910) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "book_pages", primary_key: "book_page_id", force: :cascade do |t|
    t.integer "book_id"
    t.string  "page_type",    limit: 15, null: false
    t.binary  "page_content",            null: false
  end

  create_table "book_subscribers", primary_key: "book_subscriber_id", force: :cascade do |t|
    t.integer  "book_id"
    t.integer  "user_id"
    t.boolean  "is_active",               default: true,                  null: false
    t.string   "created_by",   limit: 30,                                 null: false
    t.datetime "created_date",            default: '2017-02-08 11:10:14', null: false
    t.string   "updated_by",   limit: 30,                                 null: false
    t.datetime "updated_date",            default: '2017-02-08 11:10:14', null: false
  end

  create_table "book_transactions", primary_key: "book_transaction_id", id: :bigserial, force: :cascade do |t|
    t.integer  "book_id"
    t.integer  "user_id"
    t.integer  "status_id",     limit: 2
    t.datetime "borrowed_date"
    t.datetime "due_date"
    t.datetime "return_date"
    t.string   "created_by",    limit: 30,                                 null: false
    t.datetime "created_date",             default: '2017-02-08 11:10:14', null: false
    t.string   "updated_by",    limit: 30,                                 null: false
    t.datetime "updated_date",             default: '2017-02-08 11:10:14', null: false
  end

  create_table "books", primary_key: "book_id", force: :cascade do |t|
    t.string   "book_name",        limit: 50,                                  null: false
    t.string   "author_name",      limit: 50
    t.string   "edition",          limit: 10
    t.string   "publication_name", limit: 50
    t.string   "publication_year", limit: 4
    t.string   "description",      limit: 500
    t.integer  "user_id"
    t.integer  "status_id",        limit: 2
    t.datetime "borrowed_date"
    t.datetime "due_date"
    t.datetime "return_date"
    t.boolean  "is_active",                    default: true,                  null: false
    t.string   "created_by",       limit: 30,                                  null: false
    t.datetime "created_date",                 default: '2017-02-08 11:10:14', null: false
    t.string   "updated_by",       limit: 30,                                  null: false
    t.datetime "updated_date",                 default: '2017-02-08 11:10:14', null: false
  end

  create_table "roles", primary_key: "role_id", force: :cascade do |t|
    t.string "role_name", limit: 15, null: false
    t.index ["role_name"], name: "unique_roles_role_name", unique: true, using: :btree
  end

  create_table "statuses", primary_key: "status_id", force: :cascade do |t|
    t.string "status_name", limit: 15, null: false
    t.index ["status_name"], name: "unique_statuses_status_name", unique: true, using: :btree
  end

  create_table "user_roles", primary_key: "user_role_id", force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id", limit: 2
  end

  create_table "users", primary_key: "user_id", force: :cascade do |t|
    t.string   "first_name",    limit: 30
    t.string   "last_name",     limit: 20
    t.string   "email_address", limit: 30,                                 null: false
    t.string   "password",      limit: 20,                                 null: false
    t.string   "mobile_number", limit: 15
    t.boolean  "is_active",                default: true,                  null: false
    t.string   "created_by",    limit: 30,                                 null: false
    t.datetime "created_date",             default: '2017-02-08 11:10:13', null: false
    t.string   "updated_by",    limit: 30,                                 null: false
    t.datetime "updated_date",             default: '2017-02-08 11:10:13', null: false
    t.boolean  "is_new_user",              default: true,                  null: false
    t.index ["email_address"], name: "unique_users_email_address", unique: true, using: :btree
  end

  add_foreign_key "book_pages", "books", primary_key: "book_id", name: "fk_book_pages_books_book_id"
  add_foreign_key "book_subscribers", "books", primary_key: "book_id", name: "fk_book_subscribers_books_book_id"
  add_foreign_key "book_subscribers", "users", primary_key: "user_id", name: "fk_book_subscribers_users_user_id"
  add_foreign_key "book_transactions", "books", primary_key: "book_id", name: "fk_book_transactions_books_book_id"
  add_foreign_key "book_transactions", "statuses", primary_key: "status_id", name: "fk_book_transactions_statuses_status_id"
  add_foreign_key "book_transactions", "users", primary_key: "user_id", name: "fk_book_transactions_users_user_id"
  add_foreign_key "books", "statuses", primary_key: "status_id", name: "fk_books_statuses_status_id"
  add_foreign_key "books", "users", primary_key: "user_id", name: "fk_books_users_user_id"
  add_foreign_key "user_roles", "roles", primary_key: "role_id", name: "fk_user_roles_roles_role_id"
  add_foreign_key "user_roles", "users", primary_key: "user_id", name: "fk_user_roles_users_user_id"
end
