module Code42Template
  module Adapters
    class Heroku
      HEROKU_BUILDPACK_URLS = %w(
        heroku/nodejs
        heroku/ruby
        https://github.com/febeling/webpack-rails-buildpack.git
      )

      def initialize(app_builder)
        @app_builder = app_builder
      end

      def create_heroku_apps(flags)
        create_staging_heroku_app(flags)
        create_production_heroku_app(flags)
      end

      def create_deploy_script
        @app_builder.copy_file "bin_deploy", "bin/deploy"
        @app_builder.run "chmod a+x bin/deploy"
      end

      def update_readme_with_deploy
        instructions = <<~MARKDOWN
        ## Deploying

        If you have previously run the `./bin/setup` script,
        you can deploy to staging and production with:

            $ ./bin/deploy staging
            $ ./bin/deploy production

        We currently use the following buildpacks:

        - heroku/nodejs
        - heroku/ruby
        - https://github.com/febeling/webpack-rails-buildpack.git

        Please be sure to configure these buildpacks in the same sequence
        presented here in both staging and production, or else the deploy will
        not work.
        MARKDOWN

        @app_builder.append_file "README.md", instructions
      end

      def set_heroku_remotes
        remotes = <<~SHELL
          #{command_to_join_heroku_app('staging')}
          #{command_to_join_heroku_app('production')}

          git config heroku.remote staging
        SHELL

        @app_builder.append_file 'bin/setup', remotes
      end

      def create_staging_heroku_app(flags)
        app_name = heroku_app_name_for('staging')

        run_toolbelt_command "create #{app_name} #{flags}", "staging"
      end

      def create_production_heroku_app(flags)
        app_name = heroku_app_name_for('production')

        run_toolbelt_command "create #{app_name} #{flags}", "production"
      end

      def set_heroku_rails_secrets
        %w(staging production).each do |environment|
          run_toolbelt_command(
            "config:add SECRET_KEY_BASE=#{generate_secret}",
            environment,
          )
        end
      end

      def set_heroku_rails_environment
        %w(staging production).each do |environment|
          run_toolbelt_command("config:add RAILS_ENV=production", environment)
        end
      end

      def create_review_apps_setup_script
        @app_builder.template(
          'bin_setup_review_app.erb',
          'bin/setup_review_app',
          force: true,
        )
        @app_builder.run 'chmod a+x bin/setup_review_app'
      end

      def create_heroku_pipeline
        run_toolbelt_command(
          "pipelines:create #{heroku_app_name} \
            -a #{heroku_app_name}-staging --stage staging",
          'staging',
        )

        run_toolbelt_command(
          "pipelines:add #{heroku_app_name} \
            -a #{heroku_app_name}-production --stage production",
          'production',
        )
      end

      def configure_heroku_buildpacks
        %w(staging production).each do |environment|
          app_name = heroku_app_name_for(environment)

          run_toolbelt_command("buildpacks:clear -a #{app_name}", environment)

          HEROKU_BUILDPACK_URLS.each do |buildpack_url|
            run_toolbelt_command(
              "buildpacks:add #{buildpack_url} -a #{app_name}",
              environment
            )
          end
        end
      end

      def set_heroku_serve_static_files
        %w(staging production).each do |environment|
          run_toolbelt_command(
            'config:add RAILS_SERVE_STATIC_FILES=true',
            environment,
          )
        end
      end

      def set_heroku_application_host
        %w(staging production).each do |environment|
          run_toolbelt_command(
            "config:add APPLICATION_HOST=#{heroku_app_name}-#{environment}.herokuapp.com",
            environment,
          )
        end
      end

      private

      def command_to_join_heroku_app(environment)
        heroku_app_name = heroku_app_name_for(environment)

        <<~SHELL
        if heroku join --app #{heroku_app_name} &> /dev/null; then
          git remote add #{environment} git@heroku.com:#{heroku_app_name}.git || true
          printf 'You are a collaborator on the "#{heroku_app_name}" Heroku app\n'
        else
          printf 'Ask for access to the "#{heroku_app_name}" Heroku app\n'
        fi
        SHELL
      end

      def heroku_app_name
        @app_builder.app_name.dasherize
      end

      def heroku_app_name_for(environment)
        "#{heroku_app_name}-#{environment}"
      end

      def generate_secret
        SecureRandom.hex(64)
      end

      def run_toolbelt_command(command, environment)
        @app_builder.run("heroku #{command} --remote #{environment}")
      end
    end
  end
end
