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

    def create_application_layout
      template 'code42_layout.html.erb.erb',
        'app/views/layouts/application.html.erb',
        force: true
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
        'spec/helpers',
        'spec/support/matchers',
        'spec/support/mixins',
        'spec/support/shared_examples'
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
  end
end
