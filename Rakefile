#!/usr/bin/env rake
require 'bundler'
require 'octokit'

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
  if ENV['TRAVIS_PULL_REQUEST'] != 'false'
    puts 'Running pronto on pronto'

    puts ENV['TRAVIS_BRANCH']
    puts ENV['TRAVIS_COMMIT']
    puts ENV['TRAVIS_COMMIT_RANGE']
    puts ENV['TRAVIS_PULL_REQUEST']
    puts ENV['TRAVIS_REPO_SLUG']

    access_token =  ENV['GITHUB_ACCESS_TOKEN']
    repo = ENV['TRAVIS_REPO_SLUG']
    pull_request_number = ENV['TRAVIS_PULL_REQUEST']

    client = Octokit::Client.new
    pull_request = client.pull_request(repo, pull_request_number)

    system('gem install pronto-rubocop')
    system("pronto exec -c #{pull_request.base.sha} -f github -t #{access_token} -r rubocop")
  end
end

task(:default).clear
task default: [:bundle, :spec, :pronto]
