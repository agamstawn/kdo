class CreateKendaraanDinas < ActiveRecord::Migration[8.1]
  def change
    create_table :kendaraan_dinas do |t|
      t.string :nomor_polisi, null: false
      t.string :merek, null: false
      t.string :model, null: false
      t.integer :tahun_produksi, null: false
      t.string :warna, null: false
      t.integer :status, null: false, default: 0
      t.references :perangkat_daerah, null: false, foreign_key: true
      t.integer :penanggung_jawab_id, null: false

      t.timestamps
    end
    add_index :kendaraan_dinas, :nomor_polisi, unique: true
    add_index :kendaraan_dinas, :penanggung_jawab_id
    add_foreign_key :kendaraan_dinas, :pegawais, column: :penanggung_jawab_id
  end
end
