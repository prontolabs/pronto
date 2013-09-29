require 'pronto'
require 'octokit'
require 'rake'
require 'rake/tasklib'

module Pronto
  module RakeTask
    # Provides a custom rake task to use with Travis.
    #
    # require 'rubocop/rake/travis_pull_request'
    # Pronto::Rake::TravisPullRequest.new
    class TravisPullRequest < Rake::TaskLib
      attr_accessor :name
      attr_accessor :verbose

      def initialize(*args, &task_block)
        setup_ivars(args)

        unless ::Rake.application.last_comment
          desc 'Run Pronto on Travis Pull Request'
        end

        task(name, *args) do |_, task_args|
          RakeFileUtils.send(:verbose, verbose) do
            if task_block
              task_block.call(*[self, task_args].slice(0, task_block.arity))
            end
            run_task(verbose)
          end
        end
      end

      def run_task(verbose)
        return if pull_request_number == 'false'

        client = Octokit::Client.new

        pull_request = client.pull_request(repo_slug, pull_request_number)
        formatter = ::Pronto::Formatter::GithubFormatter.new

        ::Pronto.gem_names.each { |gem_name| require "pronto/#{gem_name}" }
        ::Pronto.run(pull_request.base.sha, '.', formatter)
      end

      private

      def pull_request_number
        ENV['TRAVIS_PULL_REQUEST']
      end

      def repo_slug
        ENV['TRAVIS_REPO_SLUG']
      end

      def setup_ivars(args)
        @name = args.shift || :pronto_travis_pull_request
        @verbose = true
      end
    end
  end
end
