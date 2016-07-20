ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'
SimpleCov.start

require_relative '../config/environment'

if Rails.env.production?
  abort 'The Rails environment is running in production mode!'
end

require 'spec_helper'
require 'rspec/rails'
require 'capybara/poltergeist'

ActiveRecord::Migration.maintain_test_schema!

Capybara.javascript_driver = :poltergeist
Capybara.default_driver = :rack_test

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.before :suite do
    DatabaseCleaner.clean_with :truncation
  end

  config.before :each do
    DatabaseCleaner.strategy = :transaction
  end

  config.before :each, type: :feature do
    DatabaseCleaner.strategy = :truncation
  end

  config.around :each do |example|
    DatabaseCleaner.start
    example.run
    DatabaseCleaner.clean
  end
end
