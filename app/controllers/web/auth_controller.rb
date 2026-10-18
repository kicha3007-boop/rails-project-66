module Web
  class AuthController < ApplicationController
    def callback
      auth = request.env["omniauth.auth"]
      user = User.find_or_initialize_by(email: auth.info.email.to_s.downcase)
      user.nickname = auth.info.nickname
      user.name = auth.info.name
      user.image_url = auth.info.image
      user.token = auth.credentials.token
      user.save!

      sign_in(user)
      redirect_to repositories_path, notice: t(".success")
    end
  end
end
