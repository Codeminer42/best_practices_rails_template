require 'feature_helper'

RSpec.feature 'feature smoke test' do
  it 'works with js', js: true do
    visit '/'

    expect(page).to have_content('It works!')
  end

  it 'works without js' do
    visit '/'

    expect(page).to have_content('It works!')
  end
end
