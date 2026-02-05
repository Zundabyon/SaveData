Rails.application.routes.draw do
  # Devise
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  # ダッシュボード（ログイン後の拠点）
  resource :dashboard, only: :show

  # ゲーム管理
  resources :games, except: :index do
    member do
      get    :confirm_destroy  # 削除確認画面
      delete :remove_cover_image  # カバー画像削除
    end
  end

  # 静的ページ
  get "/terms", to: "pages#terms", as: :terms
  get "/privacy_policy", to: "pages#privacy_policy", as: :privacy_policy
  get "/how_to", to: "pages#how_to", as: :how_to

  # ログイン済みユーザーの root
  authenticated :user do
    root to: "dashboards#show", as: :authenticated_root
  end

  # 未ログインユーザーの root
  devise_scope :user do
    root to: "devise/sessions#new"
  end

  # Rails 標準
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
