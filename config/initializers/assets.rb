# config/initializers/assets.rb

Rails.application.config.assets.version = "1.0"
Rails.application.config.assets.css_compressor = nil

# tailwind.css を追加
Rails.application.config.assets.precompile += %w( tailwind.css application.css )