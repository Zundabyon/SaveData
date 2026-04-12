# テストのカバレッジ率を測定するための設定
# add_filterでテストの除外ファイル指定
require 'simplecov'
SimpleCov.start 'rails' do
  add_filter '/channels/'
  add_filter '/jobs/'
  add_filter 'app/controllers/users/omniauth_callbacks_controller.rb'
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
  expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
  mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
