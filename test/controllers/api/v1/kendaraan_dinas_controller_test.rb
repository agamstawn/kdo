require "test_helper"

class Api::V1::KendaraanDinasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dinas = PerangkatDaerah.create!(nama: "Dinas Kendaraan")
    @pegawai = Pegawai.create!(nama: "Dian", nip: "198001012005012102", jabatan: "Pengelola", golongan: "III/a", perangkat_daerah: @dinas)
    @params = { nomor_polisi: "B 123 API", merek: "Toyota", model: "Avanza", tahun_produksi: 2022, warna: "Hitam", status: "baik", perangkat_daerah_id: @dinas.id, penanggung_jawab_id: @pegawai.id }
  end

  test "supports filtered, paginated CRUD for vehicles" do
    post api_v1_kendaraan_dinas_url, params: { kendaraan_dinas: @params }, as: :json
    assert_response :created
    id = JSON.parse(response.body).fetch("id")

    get api_v1_kendaraan_dinas_url, params: { q: "123", status: "baik", perangkat_daerah_id: @dinas.id, per_page: 1 }, as: :json
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal 1, body.fetch("meta").fetch("total_count")
    assert_equal "B 123 API", body.fetch("data").first.fetch("nomor_polisi")
    get api_v1_kendaraan_dina_url(id), as: :json
    assert_response :success
    patch api_v1_kendaraan_dina_url(id), params: { kendaraan_dinas: { status: "rusak_ringan" } }, as: :json
    assert_response :success
    delete api_v1_kendaraan_dina_url(id), as: :json
    assert_response :no_content
  end
end
