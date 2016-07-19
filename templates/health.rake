if Rails.env.development? || Rails.env.test?
  def run_command(command)
    description = "Running '#{command}'"
    separator = '-' * description.length

    puts '', separator, description, separator, ''

    system("bundle exec #{command}") or fail(
      "There was an error while running '#{command}'"
    )
  end

  desc 'Checks app health: runs tests, security checks and rubocop'
  task :health do
    run_command 'rspec'
    run_command 'npm run test'
    run_command 'bundle-audit update'
    run_command 'bundle-audit check'
    run_command 'brakeman -z'
    run_command 'rubocop'
  end
end
