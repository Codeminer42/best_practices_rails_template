require 'bundler/setup'

require (Pathname.new(__FILE__).dirname + '../lib/code42template').expand_path

Dir['./spec/support/**/*.rb'].each { |file| require file }

RSpec.configure do |config|
  config.include Code42TemplateTestHelpers

  config.before(:all) do
    add_fakes_to_path
    create_tmp_directory
  end
end
