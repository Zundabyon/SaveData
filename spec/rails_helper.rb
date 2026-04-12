# RSpecの基本的な設定やヘルパーメソッドを読み込むための行。RSpecを使用してテストを書く際には、この行が必要。
require 'spec_helper'
# 環境変数をテスト環境に設定するための行。これにより、テストが実行される際に適切な環境が使用されるようになります。
ENV['RAILS_ENV'] ||= 'test'
# 環境設定を読み込むための行。これにより、テストが実行される際にRailsの機能やモデルなどが利用できるようになります。
require_relative '../config/environment'
# テストが誤って本番環境で実行されるのを防ぐための安全策です。もしRailsが本番環境で実行されている場合、テストは中止されます。
abort("The Rails environment is running in production mode!") if Rails.env.production?
# RSpecとRailsを統合するための行。これにより、RSpecの機能がRailsアプリケーション内で利用できるようになります。
require 'rspec/rails'
# コントローラーテストでassignsを使うためのgem
require 'rails-controller-testing'



begin
  # データベースのマイグレーションが保留中でないことを確認するための行。これにより、テストが実行される前にデータベースが最新の状態であることが保証されます。
  # もしマイグレーションが保留中の場合、エラーが発生し、テストは中止されます。
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end


# RSpecの設定を行うためのブロック
RSpec.configure do |config|
  config.before(:each, type: :request) do
  host! 'localhost'
  end
  # テストで使用するフィクスチャのパスを指定します。これにより、テストデータを定義したファイルが正しく読み込まれるようになります。
  config.fixture_paths = [ Rails.root.join('spec/fixtures') ]
  # buildはFactoryBotのメソッドなのに、RSPECにFactoryBot使うよ！って教えてなかったから怒られた感じなので追加
  config.include FactoryBot::Syntax::Methods
  # コントローラーテストでassignsを使うための設定
  # TemplateAssertions が reset_template_assertion を提供するため3つ全て必要
  config.include Rails::Controller::Testing::TestProcess, type: :controller
  config.include Rails::Controller::Testing::TemplateAssertions, type: :controller
  config.include Rails::Controller::Testing::Integration, type: :controller
  # Deviseのテストヘルパーを追加（sign_inが使えるようになる）
  config.include Devise::Test::ControllerHelpers, type: :controller
  # コントローラーテストでビューをレンダリングしない
  config.render_views = false
  # 各テストをトランザクション内で実行する設定。これにより、テストがデータベースに与える影響を最小限に抑えることができます。
  config.use_transactional_fixtures = true
  # RSpecのマッチャーやモックの設定を行うためのブロック。ここでは、RSpecの期待値とモックの設定をカスタマイズしています。
  config.filter_rails_from_backtrace!
  # request specでsign_inが使えるようになる
  config.include Devise::Test::IntegrationHelpers, type: :request
end

require 'webmock/rspec'
# WebMockを使用して、テスト中に外部APIへのリクエストをブロックする設定。
# これにより、テストが外部サービスに依存せず、安定して実行できるようになります。
WebMock.disable_net_connect!(allow_localhost: true)
# WebMockを使用して、特定の外部APIへのリクエストを許可する設定。ここでは、ResendのAPIへのリクエストを許可しています。