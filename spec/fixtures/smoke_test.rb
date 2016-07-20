require 'rails_helper'

RSpec.describe 'rails_helper smoke test' do
  it 'is configured correctly' do
    expect(Rails.env).to be_test
    expect(RSpec.configuration.use_transactional_fixtures).to eq true
    expect(Capybara.javascript_driver).to eq :poltergeist
    expect(Capybara.default_driver).to eq :rack_test
  end
end
