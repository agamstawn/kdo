require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email_address: "admin@example.test", password: "SandiAman-2026!", password_confirmation: "SandiAman-2026!")
  end

  test "redirects unauthenticated users to the login page" do
    get root_url

    assert_redirected_to new_session_url
  end

  test "signs in with valid credentials" do
    post session_url, params: { email_address: @user.email_address, password: "SandiAman-2026!" }

    assert_redirected_to root_url
    follow_redirect!
    assert_select ".user-menu", /admin@example.test/
  end

  test "rejects invalid credentials" do
    post session_url, params: { email_address: @user.email_address, password: "kata-sandi-salah" }

    assert_response :unprocessable_entity
    assert_select ".auth-card"
    assert_select ".flash--alert", "Email atau kata sandi tidak valid."
  end

  test "signs out the current user" do
    post session_url, params: { email_address: @user.email_address, password: "SandiAman-2026!" }
    delete session_url

    assert_redirected_to new_session_url
  end
end
