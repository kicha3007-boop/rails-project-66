require "test_helper"

module Web
  class SessionsControllerTest < ActionDispatch::IntegrationTest
    test "#destroy" do
      sign_in users(:one)

      delete session_path

      assert_redirected_to root_path
      assert { !signed_in? }
    end
  end
end
