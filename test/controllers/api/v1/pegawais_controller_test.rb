require "test_helper"

class Api::V1::PegawaisControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dinas = PerangkatDaerah.create!(nama: "Dinas Pegawai")
  end

  test "supports filtered, paginated CRUD for employees" do
    post api_v1_pegawais_url, params: { pegawai: { nama: "Rina", nip: "198001012005012101", jabatan: "Analis", golongan: "III/a", perangkat_daerah_id: @dinas.id } }, as: :json
    assert_response :created
    id = JSON.parse(response.body).fetch("id")

    get api_v1_pegawais_url, params: { q: "Rina", perangkat_daerah_id: @dinas.id, per_page: 1 }, as: :json
    assert_response :success
    assert_equal 1, JSON.parse(response.body).fetch("meta").fetch("total_count")
    get api_v1_pegawai_url(id), as: :json
    assert_response :success
    patch api_v1_pegawai_url(id), params: { pegawai: { jabatan: "Koordinator" } }, as: :json
    assert_response :success
    delete api_v1_pegawai_url(id), as: :json
    assert_response :no_content
  end
end
