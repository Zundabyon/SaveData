require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Myapp
  class Application < Rails::Application
    # defaultで呼び出される設定をバージョン7.2に合わせる
    config.load_defaults 7.2
    # 日本語化
    config.i18n.default_locale = :ja
    # 念のため
    config.i18n.available_locales = [:ja, :en]
    # lib 以下を autoload_paths に追加
    config.autoload_lib(ignore: %w[assets tasks])
  end
end
