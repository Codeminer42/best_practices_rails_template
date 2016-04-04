require "spec_helper"

RSpec.describe "Create a new project with default configuration" do
  before(:all) do
    drop_dummy_database
    remove_project_directory
    run_code42template
  end

  it "uses custom Gemfile" do
    gemfile_file = IO.read("#{project_path}/Gemfile")
    expect(gemfile_file).to match(
      /^ruby "#{Code42Template::RUBY_VERSION}"$/,
    )
    expect(gemfile_file).to match(
      /^gem "rails", "#{Code42Template::RAILS_VERSION}"$/,
    )
  end

  it "ensures project specs pass" do
    Dir.chdir(project_path) do
      Bundler.with_clean_env do
        expect(`rake`).to include('0 failures')
      end
    end
  end

  it "creates .ruby-version from template's .ruby-version" do
    ruby_version_file = IO.read("#{project_path}/.ruby-version")

    expect(ruby_version_file).to eq "#{RUBY_VERSION}\n"
  end

  it "copies dotfiles" do
    %w[.env].each do |dotfile|
      expect(File).to exist("#{project_path}/#{dotfile}")
    end
  end

  it "loads secret_key_base from env" do
    secrets_file = IO.read("#{project_path}/config/secrets.yml")

    expect(secrets_file).to match(/secret_key_base: <%= ENV\["SECRET_KEY_BASE"\] %>/)
  end

  it "adds bin/setup file" do
    expect(File).to exist("#{project_path}/bin/setup")
  end

  it "makes bin/setup executable" do
    bin_setup_path = "#{project_path}/bin/setup"

    expect(File.stat(bin_setup_path)).to be_executable
  end

  it "removes comments and extra newlines from config files" do
    config_files = [
      IO.read("#{project_path}/config/application.rb"),
      IO.read("#{project_path}/config/environment.rb"),
      IO.read("#{project_path}/config/environments/development.rb"),
      IO.read("#{project_path}/config/environments/production.rb"),
      IO.read("#{project_path}/config/environments/test.rb"),
    ]

    config_files.each do |file|
      expect(file).not_to match(/.*#.*/)
      expect(file).not_to match(/^$\n/)
    end
  end

  def app_name
    Code42TemplateTestHelpers::APP_NAME
  end
end
