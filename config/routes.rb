Rails.application.routes.draw do

  # ============================================================
  # 🔐 認証系（Devise）
  # ============================================================
  devise_for :users, controllers: {
    registrations: "users/registrations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  # ログイン済みユーザーのroot
  authenticated :user do
    root to: "dashboards#show", as: :authenticated_root
  end

  # 未ログインユーザーのroot
  devise_scope :user do
    root to: "devise/sessions#new"
  end


  # ============================================================
  # 👤 ユーザー系
  # ============================================================
  resource  :dashboard, only: :show
  resources :users,     only: :show


  # ============================================================
  # 🎮 ゲーム管理系
  # ============================================================
  resources :games do
    collection do
      get :igdb_search       # IGDBからゲーム情報を検索
    end

    member do
      get    :confirm_destroy    # 削除確認画面
      delete :remove_cover_image # カバー画像削除
    end
  end


  # ============================================================
  # 🔮 AI・占い系
  # ============================================================
  # 占いおばばの部屋
  get  "uranai/index"
  post "uranai/predict", to: "uranai#predict"

  # AIレコメンド（FastAPI連携）
  namespace :api do
    get  "ai/recommend"
    post "ai/recommend"
  end

  # 共有画像の保存（X投稿フロー）
  post "/share_images", to: "share_images#create"


  # ============================================================
  # 📄 静的ページ系
  # ============================================================
  get "/terms",          to: "pages#terms",          as: :terms
  get "/privacy_policy", to: "pages#privacy_policy", as: :privacy_policy
  get "/how_to",         to: "pages#how_to",         as: :how_to


  # ============================================================
  # ⚙️ Rails標準
  # ============================================================
  get "up"             => "rails/health#show",       as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest"       => "rails/pwa#manifest",      as: :pwa_manifest

end