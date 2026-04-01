source "https://rubygems.org"

# === コアフレームワーク ===
# Rails本体：Webアプリを作るための基盤
gem "rails", "~> 7.2.3.1"

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

# === フロントエンド（CSS） ===
# CSSファイルをまとめて管理
gem "cssbundling-rails"

# Tailwind CSS：見た目を簡単に作れるツール
gem "tailwindcss-rails", "~> 2.7"

# Sass/SCSS：CSSを書きやすくする言語
gem "dartsass-rails"

# CSS/JSファイルを配信する仕組み
gem "sprockets-rails"

# === フロントエンド（JavaScript） ===
# JavaScriptファイルをまとめて管理
gem "jsbundling-rails"

# JavaScriptを読み込む（Rails 7の標準方式）
gem "importmap-rails"

# 画面の動きを簡単に作れる（ボタンクリック等）
gem "stimulus-rails"

# ページ移動を高速化（画面全体を再読み込みしない）
gem "turbo-rails"

# === 画像処理・Active Storage拡張機能 ===
gem "image_processing", "~> 1.2"
gem "active_storage_validations"
gem "sassc-rails"

# === ファイルストレージ ===
# 画像や動画をクラウドに保存するサービス
gem "cloudinary"
# RailsとCloudinaryをつなぐ
gem "activestorage-cloudinary-service"

# === API・ビュー ===
# JSON形式のデータを作る（API作成時に便利）
gem "jbuilder"

# === 認証・管理 ===
# ユーザー登録・ログイン機能
gem "devise"

# メール送信サービス（ユーザー登録の確認メール等）
gem "resend"

# GoogleやTwitterなどの外部サービスでログインするためのツール
gem "omniauth"
# GoogleのOAuth
gem "omniauth-google-oauth2"
# OAuth使う時のセキュリティ用
gem "omniauth-rails_csrf_protection"

# 管理画面を自動で作る（データの編集・削除等）
gem "rails_admin"

# === ユーティリティ ===
# 日付や時間でデータを集計（月別売上等）
gem "groupdate"

# === 環境変数管理 ===
# パスワードやAPIキーを安全に管理
gem "dotenv-rails", groups: [ :development, :test ]

# === 開発・テスト環境 ===

# === テスト環境のみで適用 ===
group :development, :test do
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"              # ダミーデータ自動生成（fakerと組み合わせて真価を発揮）
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "shoulda-matchers"              # バリデーションテストが1行で書ける
  gem "database_cleaner-active_record" # テスト後にDBをきれいにリセット
  gem "simplecov", require: false     # テストカバレッジを計測
  gem "rails-controller-testing"      # コントローラーテストでassignsを使うため
  gem "minitest", "~> 5.25"
end
# === 開発環境のみで適用 ===
group :development do
  gem "bullet"
  gem "web-console"
  gem "annotate"
end
