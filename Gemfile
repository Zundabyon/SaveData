source "https://rubygems.org"

# === コアフレームワーク ===
# Rails本体：Webアプリを作るための基盤
gem "rails", "~> 7.2.3"

# アプリの起動を速くする
gem "bootsnap", require: false

# 日時の処理に必要（WindowsやJRuby使用時）
gem "tzinfo-data", platforms: %i[ windows jruby ]

# === データベース ===
# PostgreSQLに接続するためのツール
gem "pg", "~> 1.1"

# === サーバー ===
# アプリを動かすWebサーバー
gem "puma", ">= 5.0"

# === フロントエンド（JavaScript） ===
# JavaScriptファイルをまとめて管理
gem "jsbundling-rails"

# JavaScriptを読み込む（Rails 7の標準方式）
gem "importmap-rails"

# 画面の動きを簡単に作れる（ボタンクリック等）
gem "stimulus-rails"

# ページ移動を高速化（画面全体を再読み込みしない）
gem "turbo-rails"

# === フロントエンド（CSS） ===
# CSSファイルをまとめて管理
gem "cssbundling-rails"

# Tailwind CSS：見た目を簡単に作れるツール
gem "tailwindcss-rails"

# Sass/SCSS：CSSを書きやすくする言語
gem "sassc-rails"

# CSS/JSファイルを配信する仕組み
gem "sprockets-rails"

# === API・ビュー ===
# JSON形式のデータを作る（API作成時に便利）
gem "jbuilder"

# === 認証・管理 ===
# ユーザー登録・ログイン機能
gem "devise"

# 管理画面を自動で作る（データの編集・削除等）
gem "rails_admin"

# === ファイルストレージ ===
# 画像や動画をクラウドに保存するサービス
gem "cloudinary"

# RailsとCloudinaryをつなぐ
gem "activestorage-cloudinary-service"

# === ユーティリティ ===
# 日付や時間でデータを集計（月別売上等）
gem "groupdate"

# === 環境変数管理 ===
# パスワードやAPIキーを安全に管理
gem "dotenv-rails", groups: [ :development, :test ]

# === 開発・テスト環境 ===
group :development, :test do
  # コードの途中で止めて確認できる
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # セキュリティの問題を自動チェック
  gem "brakeman", require: false

  # コードの書き方をチェック（品質向上）
  gem "rubocop-rails-omakase", require: false
end

# === 開発環境のみ ===
group :development do
  # ブラウザでエラー内容を詳しく見れる
  gem "web-console"

  # データベース構造をコードに自動記入
  gem "annotate"
end

# === テスト環境のみ ===
group :test do
  # ブラウザ操作を自動テスト
  gem "capybara"

  # テスト用のブラウザを動かす
  gem "selenium-webdriver"

  # テストデータを簡単に作る
  gem "factory_bot_rails"

  # ダミーの名前やメールアドレスを生成
  gem "faker"
end
# === 画像処理・Active Storage拡張機能 ===
gem "image_processing", "~> 1.2"
gem "active_storage_validations"
