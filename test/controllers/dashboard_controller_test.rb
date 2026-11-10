require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "renders the dashboard and vehicle form" do
    get root_url
    assert_response :success
    assert_select "h1", "Dasbor"

    get new_kendaraan_dinas_url
    assert_response :success
    assert_select "h1", "Tambah Kendaraan"
  end
end
