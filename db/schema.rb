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

ActiveRecord::Schema.define(version: 2019_01_04_164402) do

  create_table "budgets", force: :cascade do |t|
    t.string "name"
  end

  create_table "categories", force: :cascade do |t|
    t.integer "balance_cents", default: 0, null: false
    t.string "balance_currency", default: "USD", null: false
    t.integer "monthly_amount_cents", default: 0, null: false
    t.string "monthly_amount_currency", default: "USD", null: false
    t.string "name"
    t.integer "budget_id"
    t.index ["budget_id"], name: "index_categories_on_budget_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "phone_number"
    t.string "name"
    t.integer "budget_id"
    t.index ["budget_id"], name: "index_users_on_budget_id"
  end

end
