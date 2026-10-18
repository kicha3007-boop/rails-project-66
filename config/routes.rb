Rails.application.routes.draw do
  scope module: :web do
    root "home#index"

    post "auth/:provider", to: "auth#request", as: :auth_request
    get "auth/:provider/callback", to: "auth#callback", as: :callback_auth
    resource :session, only: :destroy

    resources :repositories, only: %i[index new create show] do
      scope module: :repositories do
        resources :checks, only: %i[show create]
      end
    end

    # Вход в обход GitHub OAuth для автотестов
    post "test/session", to: "test_sessions#create", as: :test_session if Rails.env.test?
  end

  namespace :api do
    resources :checks, only: :create
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
