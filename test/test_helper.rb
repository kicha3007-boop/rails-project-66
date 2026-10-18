ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest-power_assert"
require "webmock/minitest"

WebMock.disable_net_connect!

OmniAuth.config.test_mode = true

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all
  end
end

module ActionDispatch
  class IntegrationTest
    def sign_in(user)
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
        provider: "github",
        uid: user.id.to_s,
        info: { email: user.email, nickname: user.nickname, name: user.name },
        credentials: { token: user.token }
      )

      get callback_auth_path("github")
    end

    def signed_in?
      session[:user_id].present?
    end
  end
end
