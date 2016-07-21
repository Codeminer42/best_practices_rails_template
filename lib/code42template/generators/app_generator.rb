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

    class_option :heroku, type: :boolean, aliases: "-H", default: false,
      desc: "Create staging and production Heroku apps"

    class_option :heroku_flags, type: :string, default: "",
      desc: "Set extra Heroku flags"

    class_option :skip_test, type: :boolean, aliases: '-T', default: true,
      desc: 'Skip test files'

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
      invoke :setup_continuous_integration
      invoke :setup_secret_token
      invoke :create_code42_views
      invoke :configure_app
      invoke :customize_error_pages
      invoke :remove_config_comment_lines
      invoke :remove_routes_comment_lines
      invoke :setup_dotfiles
      invoke :setup_git
      invoke :setup_database
      invoke :setup_background_jobs
      invoke :create_local_heroku_setup
      invoke :create_heroku_apps
      invoke :setup_webpack_tasks
      invoke :setup_spring
      invoke :setup_javascript
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

    def setup_background_jobs
      say 'Setting up background jobs'

      build :setup_background_jogs
    end

    def create_local_heroku_setup
      say "Creating local Heroku setup"
      build :create_review_apps_setup_script
      build :create_deploy_script
      build :update_readme_with_deploy
    end

    def create_heroku_apps
      if options[:heroku]
        say "Creating Heroku apps"
        build :create_heroku_apps, options[:heroku_flags]
        build :set_heroku_serve_static_files
        build :set_heroku_remotes
        build :set_heroku_rails_secrets
        build :set_heroku_rails_environment
        build :set_heroku_application_host
        build :create_heroku_pipeline
        build :configure_heroku_buildpacks
        build :configure_automatic_deployment
      end
    end

    def setup_development_environment
      say 'Setting up the development environment'
      build :add_bullet_gem_configuration
      build :configure_quiet_assets
    end

    def setup_test_environment
      say 'Setting up the test environment'

      build :setup_test_env_action_dispatch_exceptions
      build :copy_rspec_config
      build :configure_feature_tests
    end

    def setup_production_environment
      say 'Setting up the production environment'

      build :remove_uglifier_js_compressor_config
    end

    def setup_staging_environment
      say 'Setting up the staging environment'
    end

    def setup_continuous_integration
      say 'Setting up CI configuration'

      build :setup_continuous_integration
    end

    def setup_secret_token
      say 'Moving secret token out of version control'
    end

    def create_code42_views
      say 'Creating code42 views'
    end

    def configure_app
      say 'Configuring app'

      build :add_puma_configuration
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

    def setup_webpack_tasks
      say "Setting up webpack tasks"

      build :setup_webpack_tasks
    end

    def setup_health_task
      say "Setting up health task"

      build :setup_health_task
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

    def setup_javascript
      say "Setting up javascript environment with NPM and webpack"
      say "This will also run npm install, so hold on..."

      build :setup_javascript
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
