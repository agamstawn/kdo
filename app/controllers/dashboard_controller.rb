class DashboardController < ApplicationController
  def index
    @total_kendaraan = KendaraanDinas.count
    @total_pegawai = Pegawai.count
    @total_perangkat_daerah = PerangkatDaerah.count
    @total_perawatan = RiwayatPerawatan.count
    @status_counts = KendaraanDinas.group(:status).count
    @kendaraan_terbaru = KendaraanDinas.includes(:perangkat_daerah, :penanggung_jawab).order(created_at: :desc).limit(5)
    @riwayat_terbaru = RiwayatPerawatan.includes(:kendaraan_dinas).order(tanggal: :desc).limit(5)
    @kendaraan_per_perangkat = KendaraanDinas.joins(:perangkat_daerah).group("perangkat_daerahs.nama").count
    @biaya_perawatan_per_bulan = RiwayatPerawatan.group("strftime('%Y-%m', tanggal)").sum(:biaya)
  end
end
