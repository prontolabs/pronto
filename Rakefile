#!/usr/bin/env rake
require 'bundler'
require_relative 'lib/pronto/rake_task/travis_pull_request'

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

Pronto::RakeTask::TravisPullRequest.new

task(:default).clear
task default: [:bundle, :spec, :pronto_travis_pull_request]
