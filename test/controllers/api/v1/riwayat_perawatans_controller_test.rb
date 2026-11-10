require "test_helper"

class Api::V1::RiwayatPerawatansControllerTest < ActionDispatch::IntegrationTest
  setup do
    dinas = PerangkatDaerah.create!(nama: "Dinas Perawatan")
    pegawai = Pegawai.create!(nama: "Deni", nip: "198001012005012103", jabatan: "Pengelola", golongan: "III/a", perangkat_daerah: dinas)
    @kendaraan = KendaraanDinas.create!(nomor_polisi: "B 88 API", merek: "Toyota", model: "Avanza", tahun_produksi: 2020, warna: "Putih", status: :baik, perangkat_daerah: dinas, penanggung_jawab: pegawai)
  end

  test "supports filtered, paginated CRUD for maintenance records" do
    payload = { kendaraan_dinas_id: @kendaraan.id, tanggal: Date.current, jenis: "Servis", keterangan: "Ganti oli", biaya: 250_000 }
    post api_v1_riwayat_perawatans_url, params: { riwayat_perawatan: payload }, as: :json
    assert_response :created
    id = JSON.parse(response.body).fetch("id")

    get api_v1_riwayat_perawatans_url, params: { q: "Servis", kendaraan_dinas_id: @kendaraan.id, per_page: 1 }, as: :json
    assert_response :success
    assert_equal 1, JSON.parse(response.body).fetch("meta").fetch("total_count")
    get api_v1_riwayat_perawatan_url(id), as: :json
    assert_response :success
    patch api_v1_riwayat_perawatan_url(id), params: { riwayat_perawatan: { biaya: 275_000 } }, as: :json
    assert_response :success
    delete api_v1_riwayat_perawatan_url(id), as: :json
    assert_response :no_content
  end
end
