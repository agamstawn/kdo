require "test_helper"

class RiwayatPerawatanTest < ActiveSupport::TestCase
  setup do
    dinas = PerangkatDaerah.create!(nama: "Dinas Pengujian")
    pegawai = Pegawai.create!(nama: "Nina", nip: "198001012005012009", jabatan: "Pengelola", golongan: "III/a", perangkat_daerah: dinas)
    @kendaraan = KendaraanDinas.create!(nomor_polisi: "B 99 KDO", merek: "Toyota", model: "Avanza", tahun_produksi: 2020, warna: "Putih", status: :baik, perangkat_daerah: dinas, penanggung_jawab: pegawai)
  end

  test "requires complete maintenance information" do
    riwayat = RiwayatPerawatan.new(kendaraan_dinas: @kendaraan, tanggal: Date.current, jenis: "Servis", keterangan: "Ganti oli", biaya: 250_000)

    assert_predicate riwayat, :valid?
  end

  test "rejects a negative maintenance cost" do
    riwayat = RiwayatPerawatan.new(kendaraan_dinas: @kendaraan, tanggal: Date.current, jenis: "Servis", keterangan: "Ganti oli", biaya: -1)

    assert_not_predicate riwayat, :valid?
  end
end
