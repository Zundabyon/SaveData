Rails.application.routes.draw do
  get "games/new"
  get "games/create"
  devise_for :users
  # devise_for :users は、Deviseのルーティングを自動生成するためのメソッド
  # ユーザー認証に関するルーティング（サインアップ、ログイン、ログアウト、パスワードリセットなど）を一括で設定する
  # これにより、手動で各ルートを定義する必要がなくなり、Deviseの機能を簡単に利用できるようになる
  # 例えば、users/sign_in や users/sign_out などのルートが自動的に作成される
  # これにより、ユーザー認証機能を迅速に実装できる
  # 詳細なカスタマイズも可能で、必要に応じてオプションを追加することもできる

  root to: "users#index"
  # アプリケーションのルートURL（/）にアクセスした際に、Usersコントローラーのindexアクションを呼び出す設定

  resources :users, only: %i[index show]
  # usersリソースに対して、indexとshowアクションのルーティングを自動生成する設定
  # これにより、/users（ユーザー一覧）と/users/:id（特定ユーザーの詳細）へのルートが作成される
  # 今回は認証関連を全てDeviseに任せているため、
  # usersリソースの編集、更新、削除などのアクションは不要であり、省略している
  # 入れてしまうと、Deviseと競合する可能性があるため注意が必要

  resources :games, only: %i[new create]
  # こちらはgameを登録するためのルーティング設定です。
  # newアクションとcreateアクションのみを使用するため、onlyオプションで制限しています。
  # newアクションはゲーム登録フォームの表示に使用され、createアクションはフォーム送信後のデータ保存に使用されます。

  get "up" => "rails/health#show", as: :rails_health_check
  # アプリケーションのヘルスチェック用のルートを定義
  # /up にアクセスすると、RailsのHealthコントローラーのshowアクションが呼び出される
  # これは、アプリケーションが正常に稼働しているかどうかを確認するためのエンドポイントとして使用される

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  # PWA（Progressive Web App）用のサービスワーカーファイルへのルートを定義
  # /service-worker にアクセスすると、RailsのPWAコントローラーのservice_workerアクションが呼び出される
  # これにより、PWAのオフライン機能やキャッシュ管理が可能になる
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # PWA用のマニフェストファイルへのルートを定義
  # /manifest にアクセスすると、RailsのPWAコントローラーのmanifestアクションが呼び出される
  # マニフェストファイルは、PWAの外観や動作を定義するために使用される
end
