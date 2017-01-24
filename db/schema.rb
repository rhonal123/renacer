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

ActiveRecord::Schema.define(version: 20170123221208) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clientes", force: :cascade do |t|
    t.string   "identidad",  limit: 16
    t.string   "apellidos",  limit: 120
    t.string   "nombres",    limit: 120
    t.date     "fecha"
    t.string   "direccion",  limit: 400
    t.string   "telefono",   limit: 80
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "contratos", force: :cascade do |t|
    t.integer  "cliente_id"
    t.integer  "plan_id"
    t.date     "desde"
    t.date     "hasta"
    t.float    "monto",      default: 0.0
    t.float    "total",      default: 0.0
    t.string   "estado",     default: "CREADO"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["cliente_id"], name: "index_contratos_on_cliente_id", using: :btree
    t.index ["plan_id"], name: "index_contratos_on_plan_id", using: :btree
  end

  create_table "pagos", force: :cascade do |t|
    t.integer  "contrato_id"
    t.integer  "semana"
    t.float    "monto",       default: 0.0
    t.string   "estado",      default: "pendiente"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.index ["contrato_id"], name: "index_pagos_on_contrato_id", using: :btree
  end

  create_table "planes", force: :cascade do |t|
    t.string   "nombre",      limit: 120
    t.float    "monto",                   default: 0.0
    t.text     "componentes"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "usuarios", force: :cascade do |t|
    t.string   "email",                              default: "",   null: false
    t.string   "encrypted_password",                 default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "nombres",                limit: 120,                null: false
    t.string   "username",               limit: 20,                 null: false
    t.boolean  "estado",                             default: true, null: false
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.index ["email"], name: "index_usuarios_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_usuarios_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "contratos", "clientes"
  add_foreign_key "contratos", "planes"
  add_foreign_key "pagos", "contratos"
end
