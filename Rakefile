#!/usr/bin/env rake
require 'bundler'

Bundler::GemHelper.install_tasks

desc 'Bundle the gem'
task :bundle do
  sh 'bundle install'
  sh 'gem build *.gemspec'
  sh 'gem install *.gem'
  sh 'rm *.gem'
end

task :spec do
  sh 'bundle exec rspec'
end

task :pronto do
  if ENV['TRAVIS_PULL_REQUEST']
    sh 'gem install pronto-rubocop'
    sh "pronto exec -f github -a #{ENV['GITHUB_ACCESS_TOKEN']}"
  end
end

task(:default).clear
task default: [:bundle, :spec, :pronto]
