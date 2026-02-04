source "https://rubygems.org"

# Railsフレームワーク本体（バージョン7.2.3系）
gem "rails", "~> 7.2.3"

# アセットパイプライン（CSS/JSの管理）
gem "sprockets-rails"

# PostgreSQLデータベースアダプター
gem "pg", "~> 1.1"

# アプリケーションサーバー（高速・並行処理対応）
gem "puma", ">= 5.0"

# JavaScriptをバンドル管理（webpackやesbuild等と連携）
gem "jsbundling-rails"

# Hotwire Turbo（ページ遷移の高速化・SPA風の動作）
gem "turbo-rails"

# Hotwire Stimulus（軽量なJavaScriptフレームワーク）
gem "stimulus-rails"

# CSSをバンドル管理（PostCSSやSass等と連携）
gem "cssbundling-rails"

# JSON API構築用のテンプレートエンジン
gem "jbuilder"

# タイムゾーンデータ（Windows/JRuby環境で必要）
gem "tzinfo-data", platforms: %i[ windows jruby ]

# 起動速度を向上させるキャッシュ機構
gem "bootsnap", require: false

# Tailwind CSSをRailsで簡単に利用
gem "tailwindcss-rails"

# ユーザー認証機能（ログイン・サインアップ等）
gem "devise"

# 管理画面を自動生成（CRUD操作を簡単に）
gem "rails_admin"

# 日時でのグループ化集計を簡単に（年・月・日別集計等）
gem "groupdate"

group :development, :test do
  # デバッグ用ツール（ブレークポイント設置可能）
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # セキュリティ脆弱性スキャンツール
  gem "brakeman", require: false

  # Railsプロジェクト向けコード品質チェッカー
  gem "rubocop-rails-omakase", require: false
end

group :development do
  # ブラウザ上でデバッグコンソールを表示
  gem "web-console"

  # モデルにスキーマ情報をコメントとして自動追加
  gem "annotate"
end

group :test do
  # E2Eテスト（ブラウザ操作シミュレーション）
  gem "capybara"

  # ブラウザ自動操作用ドライバー
  gem "selenium-webdriver"

  # テストデータ作成を簡単に（ファクトリパターン）
  gem "factory_bot_rails"

  # ダミーデータ生成（名前・メールアドレス等）
  gem "faker"
end

# Sass（SCSS）のコンパイル機能
gem "sassc-rails"

# JavaScriptモジュールをimportで管理（Rails 7デフォルト）
gem "importmap-rails"

# 画像・動画ホスティングサービスCloudinaryのSDK
gem "cloudinary"

# Active StorageとCloudinaryを連携させるアダプター
gem "activestorage-cloudinary-service"

# 環境変数を.envファイルから読み込む（API KEY等の管理に便利）
gem "dotenv-rails", groups: [ :development, :test ]
