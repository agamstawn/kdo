require "test_helper"

class KendaraanDinasTest < ActiveSupport::TestCase
  setup do
    @dinas_a = PerangkatDaerah.create!(nama: "Dinas A")
    @dinas_b = PerangkatDaerah.create!(nama: "Dinas B")
    @pegawai_a = Pegawai.create!(nama: "Ani", nip: "198001012005012001", jabatan: "Analis", golongan: "III/a", perangkat_daerah: @dinas_a)
    @pegawai_b = Pegawai.create!(nama: "Budi", nip: "198001012005012002", jabatan: "Analis", golongan: "III/a", perangkat_daerah: @dinas_b)
  end

  test "valid when responsible employee belongs to the same agency" do
    kendaraan = KendaraanDinas.new(nomor_polisi: "B 1 KDO", merek: "Toyota", model: "Innova", tahun_produksi: 2022, warna: "Hitam", status: :baik, perangkat_daerah: @dinas_a, penanggung_jawab: @pegawai_a)

    assert_predicate kendaraan, :valid?
  end

  test "supports only the three agreed vehicle statuses" do
    assert_equal %w[baik rusak_ringan rusak_berat], KendaraanDinas.statuses.keys
  end

  test "invalid when responsible employee belongs to a different agency" do
    kendaraan = KendaraanDinas.new(nomor_polisi: "B 2 KDO", merek: "Toyota", model: "Innova", tahun_produksi: 2022, warna: "Hitam", status: :baik, perangkat_daerah: @dinas_a, penanggung_jawab: @pegawai_b)

    assert_not_predicate kendaraan, :valid?
    assert_includes kendaraan.errors[:penanggung_jawab], "harus berasal dari perangkat daerah yang sama"
  end
end
