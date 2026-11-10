class NormalizeVehicleStatuses < ActiveRecord::Migration[8.1]
  def up
    # Status lama `tidak_aktif` tidak lagi didukung; kategorikan sebagai kerusakan berat.
    execute "UPDATE kendaraan_dinas SET status = 2 WHERE status = 3"
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Status tidak_aktif sudah dinormalisasi menjadi rusak_berat"
  end
end
