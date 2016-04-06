require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module Code42Template
  class AppGenerator < Rails::Generators::AppGenerator
    class_option :database, type: :string, aliases: "-d", default: "postgresql",
      desc: "Configure for selected database (options: #{DATABASES.join("/")})"

    class_option :skip_test_unit, type: :boolean, aliases: "-T", default: true,
      desc: "Skip Test::Unit files"

    class_option :skip_turbolinks, type: :boolean, default: true,
      desc: "Skip turbolinks gem"

    class_option :skip_bundle, type: :boolean, aliases: "-B", default: true,
      desc: "Don't run bundle install"

    def finish_template
      invoke :code42_customization
      super
    end

    def code42_customization
      invoke :customize_gemfile
      invoke :setup_development_environment
      invoke :setup_test_environment
      invoke :setup_production_environment
      invoke :setup_staging_environment
      invoke :setup_secret_token
      invoke :create_code42_views
      invoke :configure_app
      invoke :customize_error_pages
      invoke :remove_config_comment_lines
      invoke :remove_routes_comment_lines
      invoke :setup_dotfiles
      invoke :setup_git
      invoke :setup_database
      invoke :setup_bundler_audit
      invoke :setup_spring
    end

    def customize_gemfile
      build :set_ruby_to_version_being_used

      bundle_command 'install'
    end

    def setup_database
      say 'Setting up database'

      if 'postgresql' == options[:database]
        build :use_postgres_config_template
      end

      build :create_database
    end

    def setup_development_environment
      say 'Setting up the development environment'
      build :add_bullet_gem_configuration
      build :configure_quiet_assets
      build :configure_letter_opener
    end

    def setup_test_environment
      say 'Setting up the test environment'
    end

    def setup_production_environment
      say 'Setting up the production environment'
    end

    def setup_staging_environment
      say 'Setting up the staging environment'
    end

    def setup_secret_token
      say 'Moving secret token out of version control'
    end

    def create_code42_views
      say 'Creating code42 views'
    end

    def configure_app
      say 'Configuring app'
    end

    def setup_git
      if !options[:skip_git]
        say "Initializing git"
        invoke :setup_default_directories
        invoke :init_git
      end
    end

    def setup_dotfiles
      build :copy_dotfiles
    end

    def setup_default_directories
      build :setup_default_directories
    end

    def setup_bundler_audit
      say "Setting up bundler-audit"
      build :setup_bundler_audit
    end

    def init_git
      build :init_git
    end

    def customize_error_pages
      say 'Customizing the 500/404/422 pages'
      build :customize_error_pages
    end

    def remove_config_comment_lines
      build :remove_config_comment_lines
    end

    def remove_routes_comment_lines
      build :remove_routes_comment_lines
    end

    def setup_spring
      say "Springifying binstubs"
      build :setup_spring
    end

    protected

    def get_builder_class
      Code42Template::AppBuilder
    end

    def using_active_record?
      !options[:skip_active_record]
    end
  end
end
