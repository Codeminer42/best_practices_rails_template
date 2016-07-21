if Rails.env.development? || Rails.env.test?
  def run_command(command, env = {})
    description = "Running '#{command}'"
    separator = '-' * description.length

    puts '', separator, description, separator, ''

    system(env, command) or fail "There was an error while running '#{command}'"
  end

  desc 'Checks app health: runs tests, security checks and rubocop'
  task :health do
    rails_helper = Rails.root / 'spec/rails_helper.rb'

    run_command "bundle exec rspec -r#{rails_helper}", 'COVERAGE' => 'true'
    run_command 'npm run test'
    run_command 'bundle exec bundle-audit update'
    run_command 'bundle exec bundle-audit check'
    run_command 'bundle exec brakeman -z'
    run_command 'bundle exec rubocop'
  end
end
