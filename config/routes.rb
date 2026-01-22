Rails.application.routes.draw do
  # 1. 最初に devise_for を呼び出すことで、Deviseのルーティングが正しく設定される
  devise_for :users, controllers: { registrations: "users/registrations" }
  resource :dashboard, only: :show
  resources :users, only: :show
  resources :games, only: %i[new create edit update destroy]

  # 2. ログイン済みユーザー用のルート
  # ブロック内で authenticated を使う形にした。拡張性を持たせるため
  authenticated :user do
    root to: "dashboards#show", as: :authenticated_root
  end

  # 3. 未ログインユーザー用のルート
  # devise_scope で囲む
  devise_scope :user do
    root to: "devise/sessions#new"
  end

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end

