require "test_helper"

class Api::V1::PerangkatDaerahsControllerTest < ActionDispatch::IntegrationTest
  test "lists agencies as JSON" do
    PerangkatDaerah.create!(nama: "Dinas Pendidikan")

    get api_v1_perangkat_daerahs_url, as: :json

    assert_response :success
    assert_equal "Dinas Pendidikan", JSON.parse(response.body).first.fetch("nama")
  end

  test "rejects duplicate agency name" do
    PerangkatDaerah.create!(nama: "Dinas Kesehatan")

    post api_v1_perangkat_daerahs_url, params: { perangkat_daerah: { nama: "Dinas Kesehatan" } }, as: :json

    assert_response :unprocessable_entity
    assert JSON.parse(response.body).key?("errors")
  end
end
