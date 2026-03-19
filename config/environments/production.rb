require "active_support/core_ext/integer/time"
#本番環境用の設定ファイル 理解のためにコメントを追加しています。必要に応じて削除します。
Rails.application.configure do
  config.hosts << "savedata.quest"      # 独自ドメイン
  config.hosts << "www.savedata.quest"  # サブドメイン

  config.enable_reloading = false
  #コードの変更を反映させるために、アプリケーションの再起動が必要になります。
  config.eager_load = true
  #コードが事前にロードされるため、スレッドセーフなアプリケーションを構築できます。
  config.consider_all_requests_local = false
  #エラーが発生した場合、ユーザーには一般的なエラーページが表示されます。
  config.action_controller.perform_caching = true
  #コントローラーのアクションの結果がキャッシュされるため、パフォーマンスが向上します。

  config.assets.compile = false
#アセットが事前にコンパイルされていない場合、エラーが発生します。アセットは事前にコンパイルしておく必要があります。
  config.assets.initialize_on_precompile = false
#アセットのプリコンパイル中にアプリケーションを初期化しないようにします。これにより、プリコンパイルが高速化されます。
  config.active_storage.service = :cloudinary
#Active StorageはCloudinaryを使用してファイルを保存します。Cloudinaryの設定はconfig/storage.ymlで行います。
  config.force_ssl = true
#すべての通信をSSL/TLSで暗号化します。これにより、セキュリティが向上します。
  config.logger = ActiveSupport::Logger.new(STDOUT)
  #ログを標準出力に出力するように設定します。これにより、ログがコンテナやクラウド環境で簡単に収集できます。
    .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
  #ログのフォーマットをデフォルトのものに設定します。これにより、ログが一貫した形式で出力されます。
    .then { |logger| ActiveSupport::TaggedLogging.new(logger) }
  #ログにタグを追加できるようにします。これにより、ログの分析が容易になります。
  config.log_tags = [ :request_id ]
  #ログにリクエストIDをタグとして追加します。これにより、特定のリクエストに関連するログを簡単に追跡できます。
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")
  #ログレベルを環境変数RAILS_LOG_LEVELから取得し、デフォルトはinfoに設定します。これにより、ログの詳細度を柔軟に調整できます。
  config.action_mailer.perform_caching = false
  #メールのキャッシュは無効にします。これにより、メールの内容が常に最新の状態になります。
  config.i18n.fallbacks = true
  #翻訳が見つからない場合に、デフォルトのロケールの翻訳を使用するようにします。これにより、翻訳が不足している場合でもアプリケーションが正常に動作します。
  config.active_support.report_deprecations = false
  #非推奨の機能に関する警告を表示しないようにします。これにより、ログがクリーンになります。
  config.active_record.dump_schema_after_migration = false
  #マイグレーション後にスキーマをダンプしないようにします。これにより、スキーマファイルが更新されるのを防ぎます。
  config.active_record.attributes_for_inspect = [ :id ]
  #Active Recordのオブジェクトをログに出力する際に、id属性のみを表示するようにします。これにより、ログが簡潔になります。
end
