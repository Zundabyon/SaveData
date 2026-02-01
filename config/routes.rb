Rails.application.routes.draw do
  # Devise
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  # ダッシュボード（ログイン後の拠点）
  resource :dashboard, only: :show

  # ❌ users#show は使わないので削除
  # resources :users, only: :show

  # ゲーム（index / show は使わない設計）
  resources :games, except: [:index, :show] do
    member do
      get :confirm_destroy
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
