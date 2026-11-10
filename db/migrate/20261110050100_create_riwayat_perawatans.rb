class CreateRiwayatPerawatans < ActiveRecord::Migration[8.1]
  def change
    create_table :riwayat_perawatans do |t|
      t.integer :kendaraan_dinas_id, null: false
      t.date :tanggal, null: false
      t.string :jenis, null: false
      t.text :keterangan, null: false
      t.decimal :biaya, precision: 15, scale: 2

      t.timestamps
    end

    add_index :riwayat_perawatans, :kendaraan_dinas_id
    add_index :riwayat_perawatans, :tanggal
    add_foreign_key :riwayat_perawatans, :kendaraan_dinas, column: :kendaraan_dinas_id
  end
end
