# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'code42template/version'
require 'date'

Gem::Specification.new do |s|
  s.required_ruby_version = ">= #{Code42Template::RUBY_VERSION}"
  s.authors = ['codeminer42']
  s.date = Date.today.strftime('%Y-%m-%d')

  s.description = <<-HERE
Code42 template is a base Rails project used at Codeminer 42.
  HERE

  s.email = 'suporte@codeminer42.com'
  s.executables = ['code42template']
  s.extra_rdoc_files = %w[README.md]
  s.files = `git ls-files`.split("\n")
  s.homepage = 'https://github.com/Codeminer42/best_practices_rails_template'
  s.name = 'code42template'
  s.rdoc_options = ['--charset=UTF-8']
  s.require_paths = ['lib']
  s.summary = "Generate a Rails app using codeminer 42 best practices."
  s.version = Code42Template::VERSION

  s.add_dependency 'bundler'
  s.add_dependency 'rails', Code42Template::RAILS_VERSION

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'quiet_assets'
end
