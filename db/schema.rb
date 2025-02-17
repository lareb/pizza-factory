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

ActiveRecord::Schema[8.0].define(version: 2025_02_16_121647) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "crusts", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inventories", force: :cascade do |t|
    t.string "item_type"
    t.integer "item_id"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_items", force: :cascade do |t|
    t.integer "size", default: 0
    t.bigint "order_id", null: false
    t.bigint "pizza_id", null: false
    t.bigint "crust_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["crust_id"], name: "index_order_items_on_crust_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["pizza_id"], name: "index_order_items_on_pizza_id"
  end

  create_table "order_sides", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "side_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_sides_on_order_id"
    t.index ["side_id"], name: "index_order_sides_on_side_id"
  end

  create_table "order_toppings", force: :cascade do |t|
    t.bigint "order_item_id", null: false
    t.bigint "topping_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_item_id"], name: "index_order_toppings_on_order_item_id"
    t.index ["topping_id"], name: "index_order_toppings_on_topping_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "status"
    t.decimal "total_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pizzas", force: :cascade do |t|
    t.string "name"
    t.bigint "category_id", null: false
    t.decimal "price_regular"
    t.decimal "price_medium"
    t.decimal "price_large"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_pizzas_on_category_id"
  end

  create_table "sides", force: :cascade do |t|
    t.string "name"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "toppings", force: :cascade do |t|
    t.string "name"
    t.bigint "category_id", null: false
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_toppings_on_category_id"
  end

  add_foreign_key "order_items", "crusts"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "pizzas"
  add_foreign_key "order_sides", "orders"
  add_foreign_key "order_sides", "sides"
  add_foreign_key "order_toppings", "order_items"
  add_foreign_key "order_toppings", "toppings"
  add_foreign_key "pizzas", "categories"
  add_foreign_key "toppings", "categories"
end
