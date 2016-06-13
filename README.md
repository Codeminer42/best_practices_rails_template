# Codeminer 42 Rails app template

This is the base Rails application used at
[Codeminer 42](http://www.codeminer42.com/).

## Setting up the gem locally

  ```gem build code42template.gemspec```

  ```gem install ./code42template-0.0.1.gem```

  ```code42template app-name```

  Or

  ```cd bin/```

  ```./code42template ~/path/app-name```

## Gemfile

The gems in the [Gemfile template](templates/Gemfile.erb) will be appended to the generated app.

Currently the following gems are included by default:

#### Front-end
#### Development
* [Better errors](https://github.com/charliesome/better_errors) for a better and more useful error page
* [Binding of caller](https://github.com/banister/binding_of_caller) for retrieve the binding of a method's caller
* [Brakeman](https://github.com/presidentbeef/brakeman) for security vulnerabilities checking.
* [Bullet](https://github.com/flyerhzm/bullet) for help to kill N+1 queries and unused eager loading
* [Bundler Audit](https://github.com/rubysec/bundler-audit) for scanning the Gemfile for insecure dependencies based on published CVEs
* [Dotenv](https://github.com/bkeepers/dotenv) for loading environment variables
* [Spring](https://github.com/rails/spring) for fast Rails actions via pre-loading
* [Pry byebug](https://github.com/deivid-rodriguez/pry-byebug) for Pry navigation commands via byebug
* [Pry rails](https://github.com/rweng/pry-rails) for open rails console with Pry
* [Rubocop](https://github.com/bbatsov/rubocop) for static code analysis
* [Spring commands rspec](https://github.com/jonleighton/spring-commands-rspec) for rspec binstubs with Spring
* [Quiet Assets](https://github.com/evrone/quiet_assets) for muting assets pipeline log messages
* [Rubocop](https://github.com/bbatsov/rubocop) for enforcing the Ruby Style Guide
* [Rack Mini Profiler](https://github.com/MiniProfiler/rack-mini-profiler) for helping out with performance issues
* [Simplecov](https://github.com/colszowka/simplecov) for helping out with test coverage
* [factory_girl_rails](https://github.com/thoughtbot/factory_girl_rails) as a test fixture replacement
* [shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers) for providing useful Rails testing matchers
* [ffaker](https://github.com/colszowka/simplecov) for generating dummy data in tests
#### Testing
* [RSpec](https://github.com/rspec/rspec-rails) for unit testing
#### Else

## Other goodies

The template also comes with:
* The `./bin/setup` convention for new developer setup
* The `./bin/deploy` convention for deploying to Heroku
* pt-BR localization

## Dependencies

## Credits

The template uses the [Suspenders](https://github.com/thoughtbot/suspenders) gem from Thoughtbot as starting point.

[![codeminer42](http://s3.amazonaws.com/cm42_prod/assets/logo-codeminer-horizontal-c0516b1b78a8713270da02c3a0645560.png)](http://codeminer42.com)

