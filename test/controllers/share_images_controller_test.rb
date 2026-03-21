require "test_helper"

class ShareImagesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get share_images_create_url
    assert_response :success
  end
end
