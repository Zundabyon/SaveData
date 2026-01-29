Rails.application.routes.draw do
  # Devise
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  # ダッシュボード
  resource :dashboard, only: :show
  resources :users, only: :show

  # ゲーム（index / show は使わない設計）
  resources :games, except: [ :index, :show ] do
    member do
      get :confirm_destroy
    end
  end

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
