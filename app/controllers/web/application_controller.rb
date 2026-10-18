module Web
  class ApplicationController < ::ApplicationController
    helper_method :current_user, :signed_in?

    private

    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end

    def signed_in?
      current_user.present?
    end

    def sign_in(user)
      session[:user_id] = user.id
    end

    def sign_out
      session.delete(:user_id)
      @current_user = nil
    end

    def authenticate_user!
      return if signed_in?

      redirect_to root_path, alert: t("web.flash.authentication_required")
    end

    def github_client
      ApplicationContainer[:octokit_client].new(access_token: current_user.token, auto_paginate: true)
    end
  end
end
