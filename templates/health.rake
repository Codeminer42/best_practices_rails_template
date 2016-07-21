if Rails.env.development? || Rails.env.test?
  def run_command(command, env_vars = '')
    description = "Running '#{command}'"
    separator = '-' * description.length

    puts '', separator, description, separator, ''

    system("#{env_vars} bundle exec #{command}") or fail(
      "There was an error while running '#{command}'"
    )
  end

  desc 'Checks app health: runs tests, security checks and rubocop'
  task :health do
    run_command 'rspec', 'COVERAGE=true'
    run_command 'npm run test'
    run_command 'bundle-audit update'
    run_command 'bundle-audit check'
    run_command 'brakeman -z'
    run_command 'rubocop'
  end
end
