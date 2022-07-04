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

ActiveRecord::Schema[7.0].define(version: 2022_07_01_175126) do
  create_table "carts", primary_key: "cart_id", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cart_total", default: 0
    t.boolean "processed", default: false
  end

  create_table "carts_products", force: :cascade do |t|
    t.integer "product_id"
    t.integer "cart_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "product_quantity", default: 1
    t.index ["cart_id"], name: "index_carts_products_on_cart_id"
    t.index ["product_id"], name: "index_carts_products_on_product_id"
  end

  create_table "orders", primary_key: "order_id", default: 1656696834, force: :cascade do |t|
    t.integer "cart_id"
    t.integer "order_total"
    t.integer "order_tax"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_orders_on_cart_id"
  end

  create_table "products", primary_key: "product_id", force: :cascade do |t|
    t.string "product_name"
    t.text "product_title"
    t.integer "product_weight"
    t.float "product_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
