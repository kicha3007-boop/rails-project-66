require "test_helper"

module Web
  class TestSessionsControllerTest < ActionDispatch::IntegrationTest
    test "#create" do
      post test_session_path, params: { email: "new@example.com" }

      assert_response :ok
      assert { User.exists?(email: "new@example.com") }
      assert { signed_in? }
    end
  end
end
