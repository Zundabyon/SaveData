Rails.application.routes.draw do
  # 1. 最初に devise_for を記述（重要！）
  devise_for :users

  # 2. ログイン済みユーザーのルート
  authenticated :user do
    root to: "dashboards#show", as: :authenticated_root
  end

  # 3. 未ログインユーザーのルート
  # devise_scope で囲む（重要！）
  devise_scope :user do
    root to: "devise/sessions#new"
  end

  # 4. その他のルーティング
  resource :dashboard, only: :show
  resources :users, only: :show
  resources :games, only: %i[new create]

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end