require "test_helper"

class FeedbacksControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get feedbacks_new_url
    assert_response :success
  end

  test "should get create" do
    get feedbacks_create_url
    assert_response :success
  end

  test "should get thank_you" do
    get feedbacks_thank_you_url
    assert_response :success
  end
end
