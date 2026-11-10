class DashboardController < ApplicationController
  def index
    @total_kendaraan = KendaraanDinas.count
    @total_pegawai = Pegawai.count
    @total_perangkat_daerah = PerangkatDaerah.count
    @total_perawatan = RiwayatPerawatan.count
    @status_counts = KendaraanDinas.group(:status).count
    @kendaraan_baik = @status_counts.fetch("baik", 0)
    @kendaraan_perlu_perhatian = @total_kendaraan - @kendaraan_baik
    @persentase_kesiapan = @total_kendaraan.zero? ? 0 : (@kendaraan_baik.fdiv(@total_kendaraan) * 100).round
    @total_biaya_perawatan = RiwayatPerawatan.sum(:biaya)
    @kendaraan_terbaru = KendaraanDinas.includes(:perangkat_daerah, :penanggung_jawab).order(created_at: :desc).limit(5)
    @kendaraan_prioritas = KendaraanDinas.where.not(status: :baik).includes(:perangkat_daerah).order(status: :desc, tahun_produksi: :asc).limit(4)
    @riwayat_terbaru = RiwayatPerawatan.includes(:kendaraan_dinas).order(tanggal: :desc).limit(5)
    @kendaraan_per_perangkat = KendaraanDinas.joins(:perangkat_daerah).group("perangkat_daerahs.nama").count
    @biaya_perawatan_per_bulan = RiwayatPerawatan.group("strftime('%Y-%m', tanggal)").sum(:biaya).sort.last(6).to_h
  end
end
