module Web
  # Вход по email без GitHub OAuth. Маршрут объявлен только в тестовом окружении
  class TestSessionsController < ApplicationController
    skip_forgery_protection

    def create
      user = User.find_or_create_by!(email: params.require(:email).downcase) do |new_user|
        new_user.nickname = new_user.email.split("@").first
        new_user.token = "test-token"
      end
      sign_in(user)

      head :ok
    end
  end
end
