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

ActiveRecord::Schema[8.1].define(version: 2026_11_10_042010) do
  create_table "kendaraan_dinas", force: :cascade do |t|
    t.string "nomor_polisi", null: false
    t.string "merek", null: false
    t.string "model", null: false
    t.integer "tahun_produksi", null: false
    t.string "warna", null: false
    t.integer "status", default: 0, null: false
    t.integer "perangkat_daerah_id", null: false
    t.integer "penanggung_jawab_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nomor_polisi"], name: "index_kendaraan_dinas_on_nomor_polisi", unique: true
    t.index ["penanggung_jawab_id"], name: "index_kendaraan_dinas_on_penanggung_jawab_id"
    t.index ["perangkat_daerah_id"], name: "index_kendaraan_dinas_on_perangkat_daerah_id"
  end

  create_table "pegawais", force: :cascade do |t|
    t.string "nama", null: false
    t.string "nip", null: false
    t.string "jabatan", null: false
    t.string "golongan", null: false
    t.integer "perangkat_daerah_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nip"], name: "index_pegawais_on_nip", unique: true
    t.index ["perangkat_daerah_id"], name: "index_pegawais_on_perangkat_daerah_id"
  end

  create_table "perangkat_daerahs", force: :cascade do |t|
    t.string "nama", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nama"], name: "index_perangkat_daerahs_on_nama", unique: true
  end

  add_foreign_key "kendaraan_dinas", "pegawais", column: "penanggung_jawab_id"
  add_foreign_key "kendaraan_dinas", "perangkat_daerahs"
  add_foreign_key "pegawais", "perangkat_daerahs"
end
