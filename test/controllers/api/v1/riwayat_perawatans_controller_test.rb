require "test_helper"

class Api::V1::RiwayatPerawatansControllerTest < ActionDispatch::IntegrationTest
  test "creates a maintenance record through the API" do
    dinas = PerangkatDaerah.create!(nama: "Dinas API")
    pegawai = Pegawai.create!(nama: "Deni", nip: "198001012005012008", jabatan: "Pengelola", golongan: "III/a", perangkat_daerah: dinas)
    kendaraan = KendaraanDinas.create!(nomor_polisi: "B 88 API", merek: "Toyota", model: "Avanza", tahun_produksi: 2020, warna: "Putih", status: :baik, perangkat_daerah: dinas, penanggung_jawab: pegawai)

    post api_v1_riwayat_perawatans_url, params: { riwayat_perawatan: { kendaraan_dinas_id: kendaraan.id, tanggal: Date.current, jenis: "Servis", keterangan: "Ganti oli", biaya: 250_000 } }, as: :json

    assert_response :created
    assert_equal "Servis", JSON.parse(response.body).fetch("jenis")
  end
end
