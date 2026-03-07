require "test_helper"

class GamesControllerTest < ActionDispatch::IntegrationTest
  test "unauthenticated access to new redirects to login" do
    get new_game_url
    assert_redirected_to new_user_session_path
  end

  test "unauthenticated access to show redirects to login" do
    get game_url(games(:one))
    assert_redirected_to new_user_session_path
  end
end
