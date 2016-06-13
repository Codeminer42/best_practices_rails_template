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
    FileUtils.cp(
      Pathname(__dir__).join('..', 'fixtures', 'smoke_test.rb'),
      Pathname(project_path).join('spec', 'models', 'smoke_test_spec.rb')
    )

    Dir.chdir(project_path) do
      Bundler.with_clean_env do
        expect(`rake`).to include('1 example, 0 failures')
        expect(`npm run test`).to include('1 passing', '1 SUCCESS')
      end
    end
  end

  it "creates .ruby-version from template's .ruby-version" do
    ruby_version_file = IO.read("#{project_path}/.ruby-version")

    expect(ruby_version_file).to eq "#{RUBY_VERSION}\n"
  end

  it "copies dotfiles" do
    %w[.env .rspec].each do |dotfile|
      expect(File).to exist("#{project_path}/#{dotfile}")
    end
  end

  it 'copies rspec configuration' do
    %w[spec_helper.rb rails_helper.rb].each do |spec_config|
      expect(File).to exist(file_path("spec/#{spec_config}"))
    end
  end

  it 'copies NPM and javascript files' do
    %w[
      config/karma.conf.js
      config/webpack.config.js
      config/webpack.config.test.js
      config/webpack.config.test.browser.js
      spec/javascripts/index.browser.js
      spec/javascripts/index.integration.js
      spec/javascripts/unit/smoke.spec.js
      package.json
      Procfile
      mocha-webpack.opts
    ].each do |file|
      expect(File).to exist(file_path(file))
    end
  end

  it 'copies continuous integration setup' do
    expect(File).to exist(file_path('.travis.yml'))
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

  it 'sets action dispatch show exceptions to true in test env' do
    test_config = read_file('config/environments/test.rb')

    expect(test_config).to match(
      /config.action_dispatch.show_exceptions.*=.*true/
    )
    expect(test_config).not_to match(
      /config.action_dispatch.show_exceptions.*=.*false/
    )
  end

  it "adds explicit quiet_assets configuration" do
    result = IO.read("#{project_path}/config/application.rb")

    expect(result).to match(/^ +config.assets.quiet = true$/)
  end

  it "adds spring to binstubs" do
    expect(File).to exist("#{project_path}/bin/spring")

    bin_stubs = %w(rake rails rspec)
    bin_stubs.each do |bin_stub|
      expect(IO.read("#{project_path}/bin/#{bin_stub}")).to match(/spring/)
    end
  end

  it "configs bullet gem in development" do
    test_config = IO.read("#{project_path}/config/environments/development.rb")

    expect(test_config).to match /^ +Bullet.enable = true$/
    expect(test_config).to match /^ +Bullet.bullet_logger = true$/
    expect(test_config).to match /^ +Bullet.rails_logger = true$/
  end

  it "creates review apps setup script" do
    bin_setup_path = "#{project_path}/bin/setup_review_app"
    bin_setup = IO.read(bin_setup_path)

    expect(bin_setup).to include(
      "heroku run rake db:migrate --exit-code "\
      "--app #{app_name.dasherize}-staging-pr-$1"
    )
    expect(bin_setup).to include(
      "heroku ps:scale worker=1 "\
      "--app #{app_name.dasherize}-staging-pr-$1"
    )
    expect(bin_setup).to include(
      "heroku restart "\
      "--app #{app_name.dasherize}-staging-pr-$1"
    )
    expect(File.stat(bin_setup_path)).to be_executable
  end

  it "creates deploy script" do
    bin_deploy_path = "#{project_path}/bin/deploy"
    bin_deploy = IO.read(bin_deploy_path)

    expect(bin_deploy).to include("heroku run rake db:migrate --exit-code")
    expect(File.stat(bin_deploy_path)).to be_executable
  end

  it "sets up heroku specific gems" do
    gemfile_file = IO.read("#{project_path}/Gemfile")

    expect(gemfile_file).to include %{gem 'rails_12factor'}
  end

  def app_name
    Code42TemplateTestHelpers::APP_NAME
  end

  def read_file(path)
    IO.read(file_path(path))
  end

  def file_path(path)
    File.join(project_path, path)
  end
end
