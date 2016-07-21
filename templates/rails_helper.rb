ENV['RAILS_ENV'] ||= 'test'

if ENV['COVERAGE']
  require 'simplecov'

  SimpleCov.start 'rails' do
    minimum_coverage 90
    refuse_coverage_drop

    add_filter do |source_file|
      source_file.filename =~ %r{app/channels|lib/tasks}
    end
  end
end

require_relative '../config/environment'

if Rails.env.production?
  abort 'The Rails environment is running in production mode!'
end

if ENV['COVERAGE']
  %w(Controller Record Mailer Job).each do |klass|
    Object.const_get "Application#{klass}"
  end
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
