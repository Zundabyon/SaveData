Rails.application.routes.draw do


  # uranai_controller.rbのルーティング
  get "uranai/index"
  # getはHTTPリクエストの種類の一つで、データの取得を意味する。今回は/uranai/indexというURLに対してGETリクエストが送られると、UranaiControllerのindexアクションが呼び出される。
  
  post "uranai/predict", to: "uranai#predict"
  # ai_controller.rbのルーティング
  #namespaceとはURLの前に共通のパスをつけるためのもの。今回は/api/ai/recommendというURLになる。
  #getはHTTPリクエストの種類の一つで、データの取得を意味する。postはデータの送信を意味する。
  namespace :api do
    get "ai/recommend"
  end
  # ai_controller.rbのルーティング（POSTリクエスト用）
  # postとはHTTPリクエストの種類の一つで、データの送信を意味する。今回は/api/ai/recommendというURLに対してPOSTリクエストが送られると、Api::AiControllerのrecommendアクションが呼び出される。
  namespace :api do
    post 'ai/recommend'
  end


  # Devise
  devise_for :users, controllers: {
    registrations: "users/registrations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  # ダッシュボード（ログイン後の拠点）
  resource :dashboard, only: :show
  resources :users, only: [ :show ]
  # ゲーム管理
  resources :games do
    collection do # collectionはゲーム全体への操作
      get :igdb_search # ゲーム情報をigdb APIで引っ張ってくる際に必要
    end

    member do # memberは特定のゲームに対する操作
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

  # 共有画像の保存
  post "/share_images", to: "share_images#create"
end
