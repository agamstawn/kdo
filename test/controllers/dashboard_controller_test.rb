require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email_address: "dashboard@example.test", password: "SandiAman-2026!", password_confirmation: "SandiAman-2026!")
    post session_url, params: { email_address: @user.email_address, password: "SandiAman-2026!" }
  end

  test "renders the dashboard and vehicle form" do
    get root_url
    assert_response :success
    assert_select "h1", "Dasbor KDO"
    assert_select ".dashboard-hero"
    assert_select ".donut-chart"
    assert_select ".trend-chart"
    assert_select ".attention-panel"

    get new_kendaraan_dinas_url
    assert_response :success
    assert_select "h1", "Tambah Kendaraan"
  end
end
