require "forwardable"

module Code42Template
  class AppBuilder < Rails::AppBuilder
    include Code42Template::Actions
    extend Forwardable

    def readme
      template 'README.md.erb', 'README.md'
    end

    def gitignore
      copy_file "code42_gitignore", ".gitignore"
    end

    def gemfile
      template "Gemfile.erb", "Gemfile"
    end

    def provide_setup_script
      template "bin_setup", "bin/setup", force: true
      run "chmod a+x bin/setup"
    end

    def setup_secret_token
      template 'secrets.yml', 'config/secrets.yml', force: true
    end

    def create_shared_flashes
      copy_file "_flashes.html.erb", "app/views/application/_flashes.html.erb"
      copy_file "flashes_helper.rb", "app/helpers/flashes_helper.rb"
    end

    def copy_rspec_config
      copy_file 'spec_helper.rb', 'spec/spec_helper.rb'
      copy_file 'rails_helper.rb', 'spec/rails_helper.rb'
    end

    def use_postgres_config_template
      template 'postgresql_database.yml.erb', 'config/database.yml',
        force: true
    end

    def create_database
      bundle_command 'exec rake db:create db:migrate'
    end

    def set_ruby_to_version_being_used
      create_file '.ruby-version', "#{Code42Template::RUBY_VERSION}\n"
    end

    def configure_time_formats
      remove_file "config/locales/en.yml"
      template "config_locales_pt-BR.yml.erb", "config/locales/pt-BR.yml"
    end

    def setup_default_directories
      [
        'app/views/pages',
        'spec/lib',
        'spec/controllers',
        'spec/models',
        'spec/helpers',
        'spec/features',
        'spec/support/matchers',
        'spec/support/mixins',
        'spec/support/shared_examples',
        'spec/factories',
        'spec/javascripts/unit',
        'spec/javascripts/integration',
      ].each do |dir|
        empty_directory_with_keep_file dir
      end
    end

    def copy_dotfiles
      directory("dotfiles", ".")
    end

    def init_git
      run 'git init'
    end

    def customize_error_pages
      meta_tags =<<-EOS
  <meta charset="utf-8" />
  <meta name="ROBOTS" content="NOODP" />
  <meta name="viewport" content="initial-scale=1" />
      EOS

      %w(500 404 422).each do |page|
        inject_into_file "public/#{page}.html", meta_tags, after: "<head>\n"
        replace_in_file "public/#{page}.html", /<!--.+-->\n/, ''
      end
    end

    def remove_config_comment_lines
      config_files = [
        "application.rb",
        "environment.rb",
        "environments/development.rb",
        "environments/production.rb",
        "environments/test.rb",
      ]

      config_files.each do |config_file|
        path = File.join(destination_root, "config/#{config_file}")

        accepted_content = File.readlines(path).reject do |line|
          line =~ /^.*#.*$/ || line =~ /^$\n/
        end

        File.open(path, "w") do |file|
          accepted_content.each { |line| file.puts line }
        end
      end
    end

    def remove_routes_comment_lines
      replace_in_file 'config/routes.rb',
        /Rails\.application\.routes\.draw do.*end/m,
        "Rails.application.routes.draw do\nend"
    end

    def setup_test_env_action_dispatch_exceptions
      gsub_file(
        'config/environments/test.rb',
        'config.action_dispatch.show_exceptions = false',
        'config.action_dispatch.show_exceptions = true'
      )
    end

    def configure_quiet_assets
      config = <<-RUBY
    config.quiet_assets = true
      RUBY

      inject_into_class "config/application.rb", "Application", config
    end

    def setup_spring
	    bundle_command "exec spring binstub --all"
	  end

    def setup_javascript
      copy_js_root_files
      copy_js_spec_files

      copy_webpack_and_karma_config
      copy_webpack_entry_file
      inject_webpack_into_application_layout

      run "npm install"
    end

    def copy_js_root_files
      %w(package.json Procfile mocha-webpack.opts).each do |root_file|
        copy_file root_file, root_file
      end
    end

    def copy_js_spec_files
      %w(
        index.browser.js
        index.integration.js
        unit/smoke.spec.js
        integration/smoke.spec.js
      ).each do |js_spec_file|
        copy_file(
          "spec/javascripts/#{js_spec_file}",
          "spec/javascripts/#{js_spec_file}"
        )
      end
    end

    def copy_webpack_and_karma_config
      %w(
        karma.conf.js
        webpack.config.js
        webpack.config.test.js
        webpack.config.test.browser.js
      ).each do |config_file|
        copy_file config_file, "config/#{config_file}"
      end
    end

    def copy_webpack_entry_file
      copy_file(
        "application.js",
        "app/assets/javascripts/application.js",
        force: true
      )
    end

    def inject_webpack_into_application_layout
      replace_in_file(
        'app/views/layouts/application.html.erb',
        /javascript_include_tag 'application'/,
        "javascript_include_tag(*webpack_asset_paths('application'))"
      )
    end

    def add_bullet_gem_configuration
      config = <<-RUBY
  config.after_initialize do
    Bullet.enable = true
    Bullet.bullet_logger = true
    Bullet.rails_logger = true
  end

      RUBY

      inject_into_file(
        "config/environments/development.rb",
        config,
        after: "config.assets.raise_runtime_errors = true\n",
      )
    end

    def setup_bundler_audit
      copy_file "bundler_audit.rake", "lib/tasks/bundler_audit.rake"
      append_file "Rakefile", %{\ntask default: "bundler:audit"\n}
    end
  end
end
