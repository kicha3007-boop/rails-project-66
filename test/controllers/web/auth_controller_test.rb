require "test_helper"

module Web
  class AuthControllerTest < ActionDispatch::IntegrationTest
    test "#callback creates user and saves token" do
      email = Faker::Internet.email
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
        provider: "github",
        uid: "42",
        info: { email: email, nickname: "octocat", name: "Octo Cat", image: "https://example.com/a.png" },
        credentials: { token: "github-token" }
      )

      get callback_auth_path("github")

      user = User.find_by(email: email.downcase)

      assert { user }
      assert { user.token == "github-token" }
      assert { user.nickname == "octocat" }
      assert { signed_in? }
      assert_redirected_to repositories_path
    end
  end
end
