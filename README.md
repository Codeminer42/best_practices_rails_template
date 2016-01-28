# Codeminer 42 Rails app template

This is the base Rails application used at
[Codeminer 42](http://www.codeminer42.com/).

## Setuping the gem locally

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
#### Testing
#### Else

## Other goodies

The template also comes with:
* The `./bin/setup` convention for new developer setup
* The `./bin/deploy` convention for deploying to Heroku
* pt-BR localization

## Dependencies

## Credits

The template uses the [Suspenders](https://github.com/thoughtbot/suspenders) gem from Thoughtbot as starting point.


![codeminer42](http://s3.amazonaws.com/cm42_prod/assets/logo-codeminer-horizontal-c0516b1b78a8713270da02c3a0645560.png)
