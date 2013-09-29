require 'octokit'

module Pronto
  module Formatter
    class GithubFormatter
      def initialize
        access_token = ENV['GITHUB_ACCESS_TOKEN']
        @client = Octokit::Client.new(access_token: access_token)
      end

      def format(messages)
        messages.each do |message|
          @client.create_commit_comment(github_slug(message),
                                        sha(message),
                                        message.msg,
                                        message.path,
                                        message.line.new_lineno,
                                        message.line.position)
        end
      end

      private

      def github_slug(message)
        message.repo.remotes.map(&:github_slug).compact.first
      end

      def sha(message)
        blamelines = blame(message).lines
        lineno = message.line.new_lineno

        blameline = blamelines.find { |line| line.lineno == lineno }

        blameline.commit.id if blameline
      end

      def blame(message)
        @blames ||= {}
        @blames[message.path] ||= message.repo.blame(message.path)
        @blames[message.path]
      end
    end
  end
end
