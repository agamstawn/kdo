require "test_helper"

class Api::V1::PerangkatDaerahsControllerTest < ActionDispatch::IntegrationTest
  test "supports filtered, paginated CRUD for agencies" do
    pendidikan = PerangkatDaerah.create!(nama: "Dinas Pendidikan")
    PerangkatDaerah.create!(nama: "Dinas Kesehatan")

    get api_v1_perangkat_daerahs_url, params: { q: "Pendidikan", per_page: 1 }, as: :json
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal 1, body.fetch("meta").fetch("total_count")
    assert_equal "Dinas Pendidikan", body.fetch("data").first.fetch("nama")

    post api_v1_perangkat_daerahs_url, params: { perangkat_daerah: { nama: "Dinas PUPR" } }, as: :json
    assert_response :created
    created_id = JSON.parse(response.body).fetch("id")

    get api_v1_perangkat_daerah_url(created_id), as: :json
    assert_response :success
    patch api_v1_perangkat_daerah_url(created_id), params: { perangkat_daerah: { nama: "Dinas Pekerjaan Umum" } }, as: :json
    assert_response :success
    delete api_v1_perangkat_daerah_url(created_id), as: :json
    assert_response :no_content

    get api_v1_perangkat_daerah_url(0), as: :json
    assert_response :not_found
    assert_equal pendidikan.id, PerangkatDaerah.find_by!(nama: "Dinas Pendidikan").id
  end

  test "returns validation errors for duplicate agency names" do
    PerangkatDaerah.create!(nama: "Dinas Kesehatan")
    post api_v1_perangkat_daerahs_url, params: { perangkat_daerah: { nama: "Dinas Kesehatan" } }, as: :json
    assert_response :unprocessable_entity
    assert JSON.parse(response.body).key?("errors")
  end
end
