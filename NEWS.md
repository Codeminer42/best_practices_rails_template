0.0.1 (January 28 2016)

* Initial setup
* Ruby 2.3.0
* Rails 4.2.5
* App layout and flashes
* Customize error pages
* Git init and .gitignore
* Postgresql as database
* pt-BR locale
* Readme
* Remove config and routes comment lines
* Setup script
* Setup secret token

1.0.0 (April 06 2016)

* Add `quiet_assets` as development dependency
* Generate rake, rails and rspec binstubs with Spring
* Make Shoulda Matchers work with Spring
* Add `binding_of_caller` gem
* Add `better_errors` gem
* Add `pry-byebug` and `pry-rails` gems
* Add `bullet` as development dependency
* Add Bundler Audit to scan Gemfile for insecure dependencies per CVEs.
* Add Dotenv to development and test environments to load environment variables from the `.env` file.
* Add `brakeman`
* Add `letter_opener`
* Add `rubocop`

1.0.1 (July 02 2016)

* Fix bug: remove missing jquery from generated application.js

2.0.0 (July 27 2016)

* Setup rspec with reasonable default settings out of the box
* Setup capybara and database\_cleaner out of the box
* Include optional config for phantomjs / poltergeist
* Include webpack (webpack-rails) and NPM to replace sprockets' JS
* use foreman to manage processes: rails server, webpack dev server and sidekiq 
* Include JS test runners: karma and mocha
* Upgrade Ruby to 2.3.1
* Upgrade Rails to 5.0
* Drop quiet\_assets in favor of Rails 5' native similar feature
* Add Heroku support upon app creation
* Tune up deploy with Heroku
* Add Puma as the default application server
* Add codeclimate configuration
* Add sidekiq / ActiveJob as background job runner
* Add rubocop configuration
* Add rake health command and make CI use it
* Cleanup unnecessary gems
* Improve bin/setup script
* Do not remove comments from generated files anymore
* Improve README

2.1.0 (October 10 2016)

* Fix bin/setup script regarding Heroku - it does not try to join as a collaborator anymore
* Fix health rake task regarding rspec
* Add eslint / eslint configuration
* Add sinon - needs "import sinon from 'sinon';" manual require in tests
* Make it possible to generate an app without ActiveRecord
* Configure Travis CI
