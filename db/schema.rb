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

ActiveRecord::Schema.define(version: 2019_02_17_175658) do

  create_table "adicao_creditos", force: :cascade do |t|
    t.integer "empresa_id"
    t.float "valor"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "impressora_id"
    t.index ["empresa_id"], name: "index_adicao_creditos_on_empresa_id"
    t.index ["impressora_id"], name: "index_adicao_creditos_on_impressora_id"
    t.index ["user_id"], name: "index_adicao_creditos_on_user_id"
  end

  create_table "empresas", force: :cascade do |t|
    t.string "nome"
    t.float "preco_incolor"
    t.float "preco_colorida"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "impressoras", force: :cascade do |t|
    t.string "modelo"
    t.float "preco"
    t.string "tipo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "empresa_id"
    t.index ["empresa_id"], name: "index_impressoras_on_empresa_id"
  end

  create_table "printers", force: :cascade do |t|
    t.string "model"
    t.string "type"
    t.float "print_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "remocao_creditos", force: :cascade do |t|
    t.integer "empresa_id"
    t.float "valor"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "impressora_id"
    t.index ["empresa_id"], name: "index_remocao_creditos_on_empresa_id"
    t.index ["impressora_id"], name: "index_remocao_creditos_on_impressora_id"
    t.index ["user_id"], name: "index_remocao_creditos_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "nome"
    t.string "email"
    t.string "password"
    t.string "credit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.integer "empresa_id"
    t.index ["empresa_id"], name: "index_users_on_empresa_id"
  end

end
