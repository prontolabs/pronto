require 'octokit'

module Pronto
  module Formatter
    class GithubFormatter
      attr_writer :client

      def format(messages)
        messages.each do |message|
          @client.create_commit_comment(github_slug(message),
                                        sha(message),
                                        message.msg,
                                        message.path,
                                        message.line.new_lineno)
        end

        "#{messages.count} pronto messages posted to GitHub"
      end

      private

      def github_slug(message)
        message.repo.remotes.map(&:github_slug).compact.first
      end

      def sha(message)
        blamelines = blame(message).lines
        lineno = message.line.new_lineno

        blameline = blamelines.detect { |line| line.lineno == lineno }

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
